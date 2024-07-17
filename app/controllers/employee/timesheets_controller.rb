class Employee::TimesheetsController < EmployeeController
  def index
    @time_logs = current_employee.time_logs.order(log_date: :desc)
  end

  def project_time_sheet
    @project = EmployeeProject.find(params[:employee_project_id]).project
    @all_time_logs = current_employee.time_logs.where(employee_project_id: params[:employee_project_id])
    @total_number_of_tasks = @all_time_logs.pluck(:task_id).uniq.count
    @total_time_spent = "#{@all_time_logs.pluck(:time_in_hours).sum} hours"
    @total_working_days = @all_time_logs.pluck(:log_date).uniq.count
  end

  def log_time
    @time_log = current_employee.time_logs.new
  end

  def edit_logged_time
    @time_log = current_employee.time_logs.find(params[:id])
  end
end
