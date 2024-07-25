class Task < ApplicationRecord
  belongs_to :employee
  belongs_to :project
  has_many :time_logs
  validates :title, :number, presence: true, uniqueness: true
  scope :created_between, -> (start_date, end_date = nil) {
    end_date ||= start_date  # Set end_date to start_date if end_date is nil
    where('tasks.created_at >= ? AND tasks.created_at <= ?', start_date.beginning_of_day, end_date.end_of_day)
  }
  
  def display_title
    "#{number} - #{title}".strip
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title number] + _ransackers.keys
  end

  def self.ransackable_associations(auth_object = nil)
    %w[project]
  end
end
