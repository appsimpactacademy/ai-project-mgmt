class Employee::TimesheetsController < EmployeeController
  include CsvExportDefinitions
  def index
    @time_logs = current_employee.time_logs.order(log_date: :desc)
    respond_to do |format|
      format.html
      format.csv { send_data CsvExport.new(TimeLog.all, TIME_LOG_HEADERS, TIME_LOG_MAPPINGS).generate_csv, filename: "time_logs-#{Date.today}.csv" }
    end
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
