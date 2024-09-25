class Employee::TimesheetsController < EmployeeController
  include Filterable
  include Pagy::Backend
  include CsvExportDefinitions
  include CsvExportable

  def index
    @employee_projects = current_employee.employee_projects.includes(:project)
    @projects = current_employee.projects.where(id: @employee_projects.pluck(:project_id))
    @q = current_employee.time_logs.includes(employee_project: :project).order(log_date: :desc).ransack(params[:q])
    @time_logs = filter_by_date_range(@q.result(distinct: true))

    respond_to do |format|
      format.html
      format.csv { handle_csv_export(@time_logs, TIME_LOG_HEADERS, TIME_LOG_MAPPINGS, employee_timesheets_path, 'time_logs') }
    end
    # Paginate the results
    @pagy, @time_logs = pagy(@time_logs, items: 5)
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
