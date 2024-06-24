class Employee::TasksController < EmployeeController
  def new
    @task = Task.new
  end
end
