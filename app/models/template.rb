class Template < ApplicationRecord
  has_one_attached :template_image
  validates :name, presence: true
end
