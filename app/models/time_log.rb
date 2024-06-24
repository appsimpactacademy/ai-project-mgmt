class TimeLog < ApplicationRecord
  STATUS = ['In Progress', 'In Review', 'Completed', 'To Do', 'On Hold', 'Cancelled', 'QA']
  HOURS = [0.25, 0.50, 0.75, 1.0, 1.25, 1.50, 1.75, 2.00, 2.25, 2.50, 2.75, 3.00]
  TASK_TYPE = ['Full Day', '1st Half', '2nd Half', 'Partial Time']
  
  belongs_to :employee
  belongs_to :employee_project
  belongs_to :task

  validates :status, :time_in_hours, presence: true
end
