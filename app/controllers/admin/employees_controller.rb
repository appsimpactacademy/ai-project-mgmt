class Admin::EmployeesController < AdminController
  before_action :set_employee, only: %i[show edit update destroy]
  def index
    @employees = current_company.employees.order(created_at: :desc)
  end

  def show
    @projects = @employee.projects
    @tasks = @employee.tasks
    @timesheet_logs = @employee.time_logs
  end

  def edit; end

  def new
    @employee = current_company.employees.new
  end

  def create
    @employee = current_company.employees.new(employee_params)
    if @employee.save
      render_turbo_stream(
        'prepend',
        'employee-list',
        'admin/employees/employee',
        { employee: @employee }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        {
          form_partial: 'admin/employees/form',
          modal_title: 'Add New employee'
        }
      )
    end
  end

  def update
    if @employee.update(employee_params)
      render_turbo_stream(
        'replace',
        "employee-item-#{@employee.id}",
        'admin/employees/employee',
        { employee: @employee }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        { 
          form_partial: 'admin/employees/form', 
          modal_title: 'Edit employee' 
        }
      )
    end
  end

  def destroy
    @employee.destroy
    render_turbo_stream(
      'remove',
      "employee-item-#{@employee.id}"
    )
  end

  private

  def set_employee
    @employee = current_company.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:job_title, :first_name, :last_name, :email, :contact_number)
  end
end
