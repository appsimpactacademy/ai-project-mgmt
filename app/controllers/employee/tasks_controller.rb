class Employee::TasksController < EmployeeController
  include CsvExportDefinitions
  include CsvExportable

  before_action :set_task, only: %i[show edit update destroy]
  before_action :load_projects, only: %i[edit new]

  def index
    @tasks = current_employee.tasks
    filter_tasks_by_date if params[:date_range].present?
    respond_to do |format|
      format.html
      format.csv { handle_csv_export(@tasks, TASK_HEADERS, TASK_MAPPINGS, employee_tasks_path, 'tasks' ) }
    end
  end

  def new
    @task = current_employee.tasks.new
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
    @tasks = current_employee.tasks.where(project_id: employee_project.project_id)
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

  # Filters tasks based on the provided date range
  def filter_tasks_by_date
    start_date, end_date = params[:date_range].split(" to ").map(&:to_date)
    end_date = end_date.end_of_day
    @tasks = @tasks.where(created_at: start_date..end_date)
  end
end
