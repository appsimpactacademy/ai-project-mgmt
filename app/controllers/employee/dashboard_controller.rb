class Employee::DashboardController < EmployeeController
  include CsvExportDefinitions
  include CsvExportable
  def index
    filter = params[:filter] || 'past_7_days'
    @time_logs = current_employee.time_logs.filter_by_days(filter)
    @total_hours = @time_logs.sum(:time_in_hours).round(1) # Calculate total hours worked

    # Group by week and calculate total hours
    @weekly_data = group_by_week(@time_logs)

    respond_to do |format|
      format.html
      format.turbo_stream
      format.json {
        Rails.logger.debug("Weekly Data: #{@weekly_data.inspect}")
        render json: { totalHours: @total_hours, labels: @weekly_data.keys.map(&:to_s), data: @weekly_data.values } 
      }
    end
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

  def group_by_week(time_logs)
    grouped_data = time_logs.group_by { |log| log.log_date.beginning_of_week }.transform_values do |logs|
      logs.sum(&:time_in_hours)
    end
    Rails.logger.debug("Grouped Data: #{grouped_data.inspect}")
    grouped_data
  end
end
