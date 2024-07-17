class Task < ApplicationRecord
  belongs_to :employee
  belongs_to :project
  has_many :time_logs
  validates :title, :number, presence: true, uniqueness: true

  def display_title
    "#{number} - #{title}".strip
  end
end
