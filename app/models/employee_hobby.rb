class EmployeeHobby < ApplicationRecord
	belongs_to :employee
  belongs_to :hobby
end
