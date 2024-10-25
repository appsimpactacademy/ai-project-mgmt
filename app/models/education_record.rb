class EducationRecord < ApplicationRecord
  belongs_to :employee

  before_validation :set_end_year

  validate :unique_company_name_for_employee
  validates :start_year, presence: true
  validates :marks, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :college_or_university, presence: true
  validate :end_year_after_start_year
  validate :presence_of_end_year
  validate :years_do_not_overlap

  private

  def set_end_year
    self.end_year = nil if is_pursuing && end_year.present?
  end
  
  def unique_company_name_for_employee
    if employee.education_records.where(course_name: course_name).where.not(id: id).exists?
      errors.add(:course_name, "already exists for this employee")
    end
  end

  def presence_of_end_year
    return unless end_year.nil? && !is_pursuing

    errors.add(:end_year, 'must be present if you are not currently pursuing here.')
  end

  def end_year_after_start_year
    if end_year.present? && start_year.present? && end_year.to_i < start_year.to_i
      errors.add(:end_year, "must be greater than or equal to the start year")
    end
  end

  def years_do_not_overlap
    # If the record is pursuing, check for overlaps with existing completed records
    if is_pursuing
      # Check if any completed records have years that overlap with the current record's start_year
      overlapping_record = employee.education_records.where.not(id: id).where(is_pursuing: false).where.not(end_year: nil).where(
        "start_year <= ? AND end_year >= ?", start_year, start_year
      ).exists?

      if overlapping_record
        errors.add(:base, "You cannot select a start year that overlaps with an existing completed education period.")
      end
    else
      # If not pursuing, check for any overlaps with completed records
      overlapping_record = employee.education_records.where.not(id: id).where(is_pursuing: false).where.not(end_year: nil).where(
        "start_year <= ? AND end_year >= ?", start_year, start_year
      ).exists?

      if overlapping_record
        errors.add(:base, "You cannot select a start year that overlaps with an existing completed education period.")
      end

      # Additional check for overlaps with other pursuing records
      if employee.education_records.where.not(id: id).where(is_pursuing: true, start_year: start_year).exists?
        errors.add(:start_year, "cannot be the same as an existing pursuing record.")
      end
    end
  end
end
