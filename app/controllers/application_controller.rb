class ApplicationController < ActionController::Base
  layout 'employee'
  before_action :authenticate_employee!
  
  def current_company
    current_employee.company
  end
end
