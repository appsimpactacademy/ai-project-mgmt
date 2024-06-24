class Admin::EmployeeProjectsController < AdminController
  before_action :set_employee_project, only: %i[show edit update destroy]
  def index
    @employee_projects = EmployeeProject.order(created_at: :desc)
  end

  def show; end

  def edit; end

  def new
    @employee_project = EmployeeProject.new
  end

  def create
    @employee_project = EmployeeProject.new(employee_project_params)
    if @employee_project.save
      render_turbo_stream(
        'prepend',
        'employee-project-list',
        'admin/employee_projects/employee_project',
        { employee_project: @employee_project }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        {
          form_partial: 'admin/employee_projects/form',
          modal_title: 'Add New Employee Assignment'
        }
      )
    end
  end

  def update
    if @employee_project.update(employee_params)
      render_turbo_stream(
        'replace',
        "employee-project-item-#{@employee_project.id}",
        'admin/employee_projects/employee_project',
        { employee_project: @employee_project }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        { 
          form_partial: 'admin/employee_projects/form', 
          modal_title: 'Edit Employee Assignment' 
        }
      )
    end
  end

  def destroy
    @employee_project.destroy
    render_turbo_stream(
      'remove',
      "employee-project-item-#{@employee_project.id}"
    )
  end

  private

  def set_employee_project
    @employee_project = EmployeeProject.find(params[:id])
  end

  def employee_project_params
    params.require(:employee_project).permit(:employee_id, :project_id, :role, :current_status, :start_date, :end_date)
  end
end
