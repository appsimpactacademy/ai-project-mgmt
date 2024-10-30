module ApplicationHelper
  include Pagy::Frontend
  def flash_class(level)
    case level
    when :notice then 'alert alert-success'
    when :alert then 'alert alert-danger' 
    end
  end

  def employee_basic_details?(employee)
    employee.first_name.present? && 
    employee.last_name.present? && 
    employee.contact_number.present? && 
    employee.email.present?
  end
end
