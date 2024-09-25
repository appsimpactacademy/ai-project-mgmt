class EducationRecord < ApplicationRecord
  belongs_to :employee

  validates :course_name, presence: true
  validates :start_year, presence: true
  validates :end_year, presence: true
  validates :marks, presence: true
  validates :college_or_university, presence: true
end
