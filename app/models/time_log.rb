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
   # Scope for filtering based on the date range
  scope :filter_by_days, ->(filter) {
    case filter
    when 'past_7_days'
      where(log_date: 7.days.ago.to_date..Date.today)
    when 'past_15_days'
      where(log_date: 15.days.ago.to_date..Date.today)
    when 'this_month'
      where(log_date: Date.today.beginning_of_month..Date.today.end_of_month)
    when 'previous_month'
      where(log_date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
    when 'overall'
      all
    else
      where(log_date: 7.days.ago.to_date..Date.today) # Default filter
    end
  }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "employee_id", "employee_project_id", "id", "log_date", "status", "task_id", "task_type", "time_in_hours", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["employee", "employee_project", "task"]
  end
end
