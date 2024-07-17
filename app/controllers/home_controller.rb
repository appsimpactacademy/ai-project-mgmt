class HomeController < ApplicationController
  def index
  end
end

# def project_time_sheet
#     @project = EmployeeProject.find(params[:employee_project_id]).project
#     @all_time_logs = current_employee.time_logs
#                                     .where(employee_project_id: params[:employee_project_id])
#                                     .includes(:task)
#                                     .select(:task_id, :time_in_hours, :log_date, :status)

#     task_ids = @all_time_logs.map(&:task_id).uniq
#     total_time_in_hours = @all_time_logs.sum(&:time_in_hours)
#     log_dates = @all_time_logs.map(&:log_date).uniq

#     @total_number_of_tasks = task_ids.count
#     @total_time_spent = "#{total_time_in_hours} hours"
#     @total_working_days = log_dates.count
#   end