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
  validates :contact_number, presence: true, uniqueness: true 

  before_save :set_default_role
  after_create :send_set_password_email


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
end
