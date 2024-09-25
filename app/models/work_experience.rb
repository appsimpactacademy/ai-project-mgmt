class WorkExperience < ApplicationRecord
  belongs_to :employee

  validates :job_title, presence: true
  validates :role, presence: true
  validates :description, length: { maximum: 150 }
  validates :company_name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, allow_blank: true
  validates :is_currently_working_here, inclusion: { in: [true, false] }
end
