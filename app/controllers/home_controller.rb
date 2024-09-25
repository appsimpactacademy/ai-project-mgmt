class HomeController < ApplicationController
  layout 'application', only: [:get_resume]
  layout 'employee', only: [:index, :select_template] # No layout for these actions
  def index
  end

  def select_template
    @templates = Template.all
  end

  def get_resume
    @template = Template.find(params[:id])
    @employee = current_employee

    # Extract the template identifier from the name
    template_identifier = @template.name.downcase.gsub(' ', '_') # Converts "Template 1" to "template_1"
    
    # Render the corresponding template
    render template: "templates/#{template_identifier}"
  end

  def download_template
    template_name = "template_#{params[:id]}" # assuming id is used to determine the template

    respond_to do |format|
      format.pdf do
        # Check if the template exists
        if lookup_context.find_template("templates/#{template_name}", [], true)
          render pdf: template_name,
                 template: "templates/#{template_name}.html.erb",
                 layout: 'pdf.html' # Optional layout for the PDF
        else
          redirect_to root_path, alert: "Template not found."
        end
      end
      format.html do
        # Handle HTML request if needed
      end
    end
  end
end
