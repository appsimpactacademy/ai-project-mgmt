class Employee::DashboardController < EmployeeController
  include CsvExportDefinitions
  def index
  end

  def assignments
    @employee_projects = current_employee.employee_projects.includes(:project)
    @projects = current_employee.projects.where(id: @employee_projects.pluck(:project_id)).pluck(:title)
  end

  def export_time_logs
    employee_project = current_employee.employee_projects.find(params[:id])
    time_logs = employee_project.time_logs

    respond_to do |format|
      format.csv { send_data CsvExport.new(time_logs, TIME_LOG_HEADERS, TIME_LOG_MAPPINGS).generate_csv, filename: "time_logs_for_project_#{employee_project.project.title}.csv" }
    end
  end
end
