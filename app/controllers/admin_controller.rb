class AdminController < ApplicationController
  layout 'admin'
  before_action :verify_admin_employee

  private

  def verify_admin_employee
    unless employee_signed_in? && current_employee.admin_employee?
      redirect_to root_path, notice: 'You are not authorized to access this page'
    end
  end

  def render_turbo_stream(action, target, partial = nil, locals = {})
    respond_to do |format|
      format.turbo_stream do
        case action
        when 'replace'
          render turbo_stream: turbo_stream.replace(target, partial:, locals:)
        when 'append'
          render turbo_stream: turbo_stream.append(target, partial:, locals:)
        when 'prepend'
          render turbo_stream: turbo_stream.prepend(target, partial:, locals:)
        when 'remove'
          render turbo_stream: turbo_stream.remove(target)
        end
      end
    end
  end
end
