class Task < ApplicationRecord
  validates :title, :number, presence: true, uniqueness: true
end
