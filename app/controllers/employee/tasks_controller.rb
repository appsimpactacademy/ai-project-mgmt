class Employee::TasksController < EmployeeController
  include Filterable
  include Pagy::Backend
  include CsvExportDefinitions
  include CsvExportable

  before_action :set_task, only: %i[show edit update destroy]
  before_action :load_projects, only: %i[edit new]

  def index
    @employee_projects = current_employee.employee_projects.includes(:project)
    @projects = current_employee.projects.where(id: @employee_projects.pluck(:project_id)).pluck(:title)
    @q = current_employee.tasks.includes(:project).ransack(params[:q])
    @tasks = filter_by_date_range(@q.result(distinct: true))
    respond_to do |format|
      format.html
      format.csv { handle_csv_export(@tasks, TASK_HEADERS, TASK_MAPPINGS, employee_tasks_path, 'tasks' ) }
    end
    # Paginate the results
    @pagy, @tasks = pagy(@tasks, items: 5)
  end
  
  def new
    @task = current_employee.tasks.new
  end

  def assign_task
    if current_employee.project_manager?
      @tasks = current_employee.tasks.includes(:project)
      @employee_projects = current_employee.employee_projects.includes(:project)
      @projects = current_employee.projects.where(id: @employee_projects.pluck(:project_id)).pluck(:title)
    end
  end

  def assign_task_to_employee
    @task = Task.find(params[:task_id])
    if @task.update(employee_id: params[:employee_id], project_id: params[:project_id])
      redirect_to employee_dashboard_path, notice: 'Task was successfully assigned.'
    else
      redirect_to employee_dashboard_path, alert: 'Failed to assign task.'
    end
  end

  def show; end

  def edit; end

  def create
    @task = current_employee.tasks.new(task_params)
    if @task.save
      render_turbo_stream(
        'prepend',
        'task-list',
        'employee/tasks/task',
        { task: @task }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        {
          form_partial: 'employee/tasks/form',
          modal_title: 'Add New Task'
        }
      )
    end
  end

  def update
    if @task.update(task_params)
      render_turbo_stream(
        'replace',
        "task-item-#{@task.id}",
        'employee/tasks/task',
        { task: @task }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        { 
          form_partial: 'employee/tasks/form', 
          modal_title: 'Edit Task' 
        }
      )
    end
  end

  def destroy
    @task.destroy
    render_turbo_stream(
      'remove',
      "task-item-#{@task.id}"
    )
  end

  def fetch_project_tasks
    employee_project = current_employee.employee_projects.find(params[:project_id])
    project_tasks = current_employee.tasks.where(project_id: employee_project.project_id)
    completed_task_ids = TimeLog.where(status: 'Completed').pluck(:task_id).uniq
    @tasks = project_tasks.where.not(id: completed_task_ids)
  end

  private

  def set_task
    @task = current_employee.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :number, :employee_id, :project_id)
  end

  def load_projects
    @projects = current_employee.projects
  end
end
