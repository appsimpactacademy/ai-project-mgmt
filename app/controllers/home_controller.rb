class HomeController < ApplicationController
  layout 'application', only: [:get_resume]
  layout 'employee', only: [:index, :select_template] # No layout for these actions
  def index
  end
end
