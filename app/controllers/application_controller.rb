class ApplicationController < ActionController::Base
  layout 'employee'
  before_action :authenticate_employee!
  
  def current_company
    current_employee.company
  end

  private

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
