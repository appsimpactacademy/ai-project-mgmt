class Admin::ProjectsController < AdminController
  before_action :set_project, only: %i[show edit update destroy]
  def index
    @projects = current_company.projects.order(created_at: :desc)
  end

  def show
    @employees = @project.employees
    @tasks = @project.tasks
  end

  def edit; end

  def new
    @project = current_company.projects.new
  end

  def create
    @project = current_company.projects.new(project_params)
    if @project.save
      render_turbo_stream(
        'prepend',
        'project-list',
        'admin/projects/project',
        { project: @project }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        {
          form_partial: 'admin/projects/form',
          modal_title: 'Add New Project'
        }
      )
    end
  end

  def update
    if @project.update(project_params)
      render_turbo_stream(
        'replace',
        "project-item-#{@project.id}",
        'admin/projects/project',
        { project: @project }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        { 
          form_partial: 'admin/projects/form', 
          modal_title: 'Edit project' 
        }
      )
    end
  end

  def destroy
    @project.destroy
    render_turbo_stream(
      'remove',
      "project-item-#{@project.id}"
    )
  end

  private

  def set_project
    @project = current_company.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :client_name, :client_company, :start_date, :end_date, :status)
  end
end
