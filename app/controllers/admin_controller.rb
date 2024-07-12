class AdminController < ApplicationController
  layout 'admin'
  before_action :verify_admin_employee

  private

  def verify_admin_employee
    unless employee_signed_in? && current_employee.admin_employee?
      redirect_to root_path, notice: 'You are not authorized to access this page'
    end
  end
end
