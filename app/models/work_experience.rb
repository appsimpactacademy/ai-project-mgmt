class WorkExperience < ApplicationRecord
  belongs_to :employee

  before_validation :clear_end_date_if_currently_working
  # Validations
  validates :job_title, length: { maximum: 100 }
  validates :role, presence: true
  validates :company_name, presence: true, uniqueness: true
  validates :description, presence: true, unless: :is_currently_working_here?
  validates :start_date, presence: true
  validates :is_currently_working_here, inclusion: { in: [true, false] }
  # Custom Validations
  validate :presence_of_end_date
  validate :end_date_greater_than_start_date
  validate :date_range_do_not_ovelaps
  

  def job_duration
    months = if end_date.present?
               ((end_date.year - start_date.year) * 12 + end_date.month - start_date.month - (end_date.day >= start_date.day ? 0 : 1)).round
             else
               ((Date.today.year - start_date.year) * 12 + Date.today.month - start_date.month - (Date.today.day >= start_date.day ? 0 : 1)).round
             end
    result = months.divmod(12)
    duration = "#{result.first} #{result.first > 1 ? 'years' : 'year'} #{result.last} #{result.last > 1 ? 'months' : 'month'}"
    if is_currently_working_here
      "#{start_date.strftime("%d %B %Y")} - Present (#{duration})"
    else
      "#{start_date.strftime("%d %B %Y")} - #{end_date.strftime("%d %B %Y")} (#{duration})"
    end
  end
  
  private

  def clear_end_date_if_currently_working
    self.end_date = nil if is_currently_working_here == true
  end

  def presence_of_end_date
    return unless end_date.nil? && !is_currently_working_here?

    errors.add(:end_date, 'must be present if you are not currently working in this company')
  end

  def end_date_greater_than_start_date
    return if end_date.nil?

    if end_date < start_date
      errors.add(:end_date, 'must be greater than start date')
    end
  end

  def date_range_do_not_ovelaps
     # Check for overlaps with existing completed records
    if is_currently_working_here
      # If currently working, check for overlaps with completed records
      overlapping_completed_record = employee.work_experiences.where.not(id: id).where(is_currently_working_here: false).where.not(end_date: nil).where(
        "start_date <= ? AND end_date >= ?", start_date, start_date
      ).exists?

      if overlapping_completed_record
        errors.add(:base, "You cannot select a start date that overlaps with an existing completed work experience period.")
      end
    else
      # If not currently working, check for overlaps with completed records
      overlapping_completed_record = employee.work_experiences.where.not(id: id).where(is_currently_working_here: false).where.not(end_date: nil).where(
        "start_date <= ? AND end_date >= ?", start_date, start_date
      ).exists?

      if overlapping_completed_record
        errors.add(:base, "You cannot select a start date and end date that overlaps with an existing completed work experience period.")
      end

      # Additional check for overlaps with other currently working records
      if employee.work_experiences.where.not(id: id).where(is_currently_working_here: true, start_date: start_date).exists?
        errors.add(:start_date, "cannot be the same as an existing currently working record.")
      end
    end
  end
end
