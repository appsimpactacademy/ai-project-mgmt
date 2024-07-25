class TimeLog < ApplicationRecord
  STATUS = ['In Progress', 'In Review', 'Completed', 'To Do', 'On Hold', 'Cancelled', 'QA']
  HOURS = []
  (0.25..10.0).step(0.25) { |n| HOURS <<  n }
  TASK_TYPE = ['Full Day', '1st Half', '2nd Half', 'Partial Time']
  
  belongs_to :employee
  belongs_to :employee_project
  belongs_to :task

  validates :status, :time_in_hours, presence: true
  scope :created_between, -> (start_date, end_date = nil) {
    end_date ||= start_date
    where(log_date: start_date..end_date)
  }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "employee_id", "employee_project_id", "id", "log_date", "status", "task_id", "task_type", "time_in_hours", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["employee", "employee_project", "task"]
  end
end
