class Task < ApplicationRecord
  belongs_to :employee
  belongs_to :project
  validates :title, :number, presence: true, uniqueness: true

  def display_title
    "#{number} - #{title}".strip
  end
end
