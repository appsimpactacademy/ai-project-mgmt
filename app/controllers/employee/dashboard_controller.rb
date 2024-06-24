class Employee::DashboardController < EmployeeController
  def index
  end

  def assignments
    @employee_projects = current_employee.employee_projects.includes(:project)
  end
end
