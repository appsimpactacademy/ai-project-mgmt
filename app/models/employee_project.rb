class EmployeeProject < ApplicationRecord
  ROLE = %w(Developer Designer Manager QA Devopps Lead)
  CURRENT_STATUS = %w(Active Inactive)
  belongs_to :employee
  belongs_to :project
  has_many :time_logs

  validates :role, :current_status, :start_date, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "current_status", "employee_id", "end_date", "id", "project_id", "role", "start_date", "updated_at"]
  end
end
