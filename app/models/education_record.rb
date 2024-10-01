class EducationRecord < ApplicationRecord
  belongs_to :employee

  validates :course_name, presence: true
  validates :start_year, presence: true
  validates :end_year, presence: true
  validates :marks, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :college_or_university, presence: true

  # Custom validation to check if end_year is greater than or equal to start_year
  validate :end_year_after_start_year

  private

  def end_year_after_start_year
    if end_year.present? && start_year.present? && end_year < start_year
      errors.add(:end_year, "must be greater than or equal to the start year")
    end
  end
end
