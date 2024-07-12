class Employee::TimesheetsController < EmployeeController
  def index
    @time_logs = current_employee.time_logs.order(log_date: :desc)
  end

  def log_time
    @time_log = current_employee.time_logs.new
  end

  def edit_logged_time
    @time_log = current_employee.time_logs.find(params[:id])
  end
end
