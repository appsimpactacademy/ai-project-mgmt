class Project < ApplicationRecord
  STATUS = %w(Active Inactive Completed Hold Finished)
  has_many :employee_projects
  has_many :employees, through: :employee_projects

  belongs_to :company
  has_many :tasks

  validates :title, :client_name, :client_company, :start_date, :status, presence: true
  validates :title, uniqueness: true
  
  def display_name
    "#{title} (#{company})"
  end
end
