class Employee::TimesheetsController < EmployeeController
  include Filterable
  def index
    @q = current_employee.time_logs.includes(employee_project: :project).order(log_date: :desc).ransack(params[:q])
    @time_logs = filter_by_date_range(@q.result(distinct: true))
  end

  def project_time_sheet
    @project = EmployeeProject.find(params[:employee_project_id]).project
    @all_time_logs = current_employee.time_logs
                                     .includes(:task)
                                     .where(employee_project_id: params[:employee_project_id])
                                     .select(:task_id, :time_in_hours, :log_date, :status)

    @card_items = {
      'Total Tasks' => @all_time_logs.map(&:task_id).uniq.count,
      'Total Time Spent' => "#{@all_time_logs.sum(&:time_in_hours)} hours",
      'Total Work Days' => @all_time_logs.map(&:log_date).uniq.count
    }
  end

  def log_time
    @time_log = current_employee.time_logs.new
  end

  def edit_logged_time
    @time_log = current_employee.time_logs.find(params[:id])
  end
end
