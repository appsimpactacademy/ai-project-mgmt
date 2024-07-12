class Employee::TimeLogsController < EmployeeController
  def new
    @time_log = current_employee.time_logs.new
  end

  def edit
    @time_log = current_employee.time_logs.find(params[:id])
    @tasks = current_employee.tasks.where(project_id: @time_log.employee_project.project_id)
  end

  def create
    @time_log = current_employee.time_logs.new(time_params)
    if @time_log.save
      render_turbo_stream(
        'prepend',
        'time-logged-list',
        'employee/time_logs/log',
        { time_log: @time_log }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        {
          form_partial: 'employee/time_logs/form',
          modal_title: 'Add Time'
        }
      )
    end
  end

  def fetch_logged_dates
    @log_dates = current_employee.time_logs.pluck(:log_date).sort.map {|date| date.strftime("%d-%m-%Y")}
    render json: @log_dates
  end

  private

  def time_params
    params.require(:time_log).permit(:description, :log_date, :status, :task_type, :time_in_hours, :task_id, :employee_project_id)
  end
end
