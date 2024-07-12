class TimeLog < ApplicationRecord
  STATUS = ['In Progress', 'In Review', 'Completed', 'To Do', 'On Hold', 'Cancelled', 'QA']
  HOURS = []
  (0.25..10.0).step(0.25) { |n| HOURS <<  n }
  TASK_TYPE = ['Full Day', '1st Half', '2nd Half', 'Partial Time']
  
  belongs_to :employee
  belongs_to :employee_project
  belongs_to :task

  validates :status, :time_in_hours, presence: true
end
