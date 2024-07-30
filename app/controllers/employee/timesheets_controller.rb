class Employee::TimesheetsController < EmployeeController
  include CsvExportDefinitions
  include CsvExportable

  def index
    @time_logs = current_employee.time_logs.order(log_date: :desc)
    filter_tasks_by_date if params[:date_range].present?
    respond_to do |format|
      format.html
      format.csv { handle_csv_export(@time_logs, TIME_LOG_HEADERS, TIME_LOG_MAPPINGS, employee_timesheets_path, 'time_logs') }
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

  private
  # Filters time_logs based on the provided date range
  def filter_tasks_by_date
    start_date, end_date = params[:date_range].split(" to ").map(&:to_date)
    end_date = end_date.end_of_day
    @time_logs = @time_logs.where(log_date: start_date..end_date)
  end
end
