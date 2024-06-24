class EmployeeProject < ApplicationRecord
  ROLE = %w(Developer Designer Manager QA Devopps Lead)
  CURRENT_STATUS = %w(Active Inactive)
  belongs_to :employee
  belongs_to :project

  validates :role, :current_status, :start_date, presence: true
end
