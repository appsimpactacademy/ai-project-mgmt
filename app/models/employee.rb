class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable, 
         :validatable, 
         :trackable
  
  has_many :employee_projects
  has_many :projects, through: :employee_projects
  belongs_to :company, optional: true
  has_many :tasks
  has_many :time_logs

  has_many :education_records, dependent: :destroy
  accepts_nested_attributes_for :education_records, allow_destroy: true

  has_many :work_experiences, dependent: :destroy
  accepts_nested_attributes_for :work_experiences, allow_destroy: true

  has_many :employee_hobbies
  has_many :hobbies, through: :employee_hobbies
  has_many :employee_skills
  has_many :skills, through: :employee_skills
  has_many :resumes, dependent: :destroy  # Add this line


  validates :first_name, :last_name, :job_title, presence: true
  validates :about, presence: true, if: :editing_record?
  validates :contact_number, presence: true, uniqueness: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits long" }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :first_and_last_name_format
  validate :validate_associated_objects

  before_save :set_default_role
  after_create :send_set_password_email


  def validate_associated_objects
    if work_experiences.blank?
      errors.add(:work_experiences, "can't be blank")
    end

    if skills.blank?
      errors.add(:skills, "can't be blank")
    end

    if hobbies.blank?
      errors.add(:hobbies, "can't be blank")
    end

    if education_records.blank?
      errors.add(:education_records, "can't be blank")
    end
  end

  def editing_record?
    persisted? # Returns true if the record has been saved (i.e., editing)
  end

  def set_default_role
    self.role = 'developer' unless role.present?
  end

  def developer?
    role == 'developer'
  end

  def admin_employee?
    role == 'admin'
  end

  def project_manager?
    role == 'project_manager'
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def password_required?
    false
  end

  def send_set_password_email
    self.send_reset_password_instructions
  end

  def first_and_last_name_format
    if first_name.present? && !first_name.match?(/\A[a-zA-Z]+\z/)
      errors.add(:first_name, "must only contain letters (A-Z, a-z)")
    end

    if last_name.present? && !last_name.match?(/\A[a-zA-Z]+\z/)
      errors.add(:last_name, "must only contain letters (A-Z, a-z)")
    end
  end
end
