class WorkExperience < ApplicationRecord
  belongs_to :employee

  # Validation for job_title length
  validates :job_title, length: { maximum: 100 }

  # Validation for presence of role
  validates :role, presence: true

  # Description is required only if not currently working here
  validates :description, presence: true, if: -> { !is_currently_working_here }

  # Presence validations
  validates :company_name, presence: true
  validates :start_date, presence: true
  
  # End date can be blank, but must follow the start date if provided
  validates :end_date, presence: true, if: -> { is_currently_working_here }

  # Ensure that is_currently_working_here is a boolean
  validates :is_currently_working_here, inclusion: { in: [true, false] }

  # Custom validation to ensure end_date is after start_date
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
