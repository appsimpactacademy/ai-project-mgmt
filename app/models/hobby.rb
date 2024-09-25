class Hobby < ApplicationRecord
	has_many :employee_hobbies
  has_many :employees, through: :employee_hobbies
end
