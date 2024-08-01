class Employee::DashboardController < EmployeeController
  include CsvExportDefinitions
  include CsvExportable
  def index
  end

  def assignments
    @employee_projects = current_employee.employee_projects.includes(:project)
    @projects = current_employee.projects.where(id: @employee_projects.pluck(:project_id)).pluck(:title)
  end

  def export_time_logs
    employee_project = current_employee.employee_projects.find(params[:id])
    @time_logs = employee_project.time_logs

    filter_tasks_by_date if params[:date_range].present?
    respond_to do |format|
      format.html
      format.csv { handle_csv_export(@time_logs, TIME_LOG_HEADERS, TIME_LOG_MAPPINGS, employee_assignments_path, 'time_logs' ) }
    end
  end

  private
  # Filters time_logs based on the provided date range
  def filter_tasks_by_date
    start_date, end_date = params[:date_range].split(" to ").map(&:to_date)
    end_date = end_date.end_of_day
    @time_logs = @time_logs.where(log_date: start_date..end_date)
  end
end
