class Employee::DashboardController < EmployeeController
  def index
  end

  def assignments
    @employee_projects = current_employee.employee_projects.includes(:project)
    @projects = current_employee.projects.where(id: @employee_projects.pluck(:project_id)).pluck(:title)
  end
end
