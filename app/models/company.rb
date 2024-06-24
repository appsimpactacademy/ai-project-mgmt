class Company < ApplicationRecord
  has_many :employees
  has_many :projects

  validates :name, :email, :contact_number, presence: true, uniqueness: true
end
