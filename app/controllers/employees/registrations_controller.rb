# frozen_string_literal: true

class Employees::RegistrationsController < Devise::RegistrationsController
  layout 'application'
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :set_template, only: [:preview_template, :get_resume]
  before_action :load_steps, only: [:edit, :update]
  before_action :set_step, only: [:edit, :update]
  before_action :build_social_network, only: [:edit, :update] # Or your relevant action
  before_action :set_employee, only: [:employee_detail, :preview_template, :get_resume]

  def edit
    if request.referer
      referer_url = URI.parse(request.referer)
      @previous_path = referer_url.path
    end
    render_step
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if update_resource(resource, account_update_params)
      set_flash_message :notice, :updated if is_navigational_format?
      bypass_sign_in resource, scope: resource_name
      if params[:step] == 'final'
        redirect_to employee_detail_path(resource), notice: 'Employee Details updated.'
      else
        @next_step_path = next_step
        if @next_step_path.present?
          redirect_to @next_step_path, locals: { step: @step }
        else
          redirect_to employee_detail_path(resource.id), notice: 'Employee Details updated.'
        end
      end
    else
      clean_up_passwords resource
      flash.now[:alert] = resource.errors.full_messages.join(', ')
      render_step
    end
  end


  def employee_detail
    if params[:id].to_i != current_employee.id
      flash[:alert] = "You are not authorized to view this profile."
      redirect_to root_path # Redirect to a safe path
    end
  end

  def select_template
    @template_names = Template.all.group_by(&:name).map { |name, templates| templates.first }
    if params[:template_name].present?
      @templates = Template.where(name: params[:template_name])
      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  def preview_template
    @template_identifier = @template.name.downcase
    # render partial: "templates/#{@template_identifier}", locals: { employee: @employee }, layout: false
  end

  def get_resume
    @template_identifier = @template.name.downcase

    respond_to do |format|
      format.html
      format.pdf do
        html_content = render_to_string(
          template: 'employees/registrations/get_resume', 
          layout: "pdf",
          formats: [:html]
        )

        pdf_service = PuppeteerPdfService.new(html_content, {
          format: 'A3',
          margin: { top: 20, bottom: 0, left: 0, right: 10 },
          template_identifier: @template_identifier 
        })

        pdf_path = pdf_service.generate

        if pdf_path && File.exist?(pdf_path)
          send_file pdf_path, type: 'application/pdf', disposition: 'inline'
        else
          flash[:error] = "PDF generation failed"
          redirect_to root_path # Specify a fallback path
        end
      end
    end
  end


  protected
  
  def build_social_network
    resource.build_social_network unless resource.social_network
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :contact_number, :job_title])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, 
      :last_name, 
      :email,
      :about,
      :contact_number, 
      :job_title,
      :profile_image,
      :password, 
      :password_confirmation,
      education_records_attributes: [:id, :course_name, :start_year, :end_year, :marks, :is_pursuing, :college_or_university, :_destroy],
      work_experiences_attributes: [:id, :job_title, :role, :description, :company_name, :start_date, :end_date, :is_currently_working_here, :_destroy],
      social_network_attributes: [
        :linkedin_url, :github_url, :stackoverflow_url, :twitter_url, :youtube_url
      ]
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [hobby_ids: [], skill_ids: []])
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    next_step_path = next_step
  end

  def set_template
    @template = Template.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Template not found."
    redirect_to root_path # Adjust to your desired path
  end

  def load_steps
    @steps = %w[profile education work hobby social_network skill]
  end

  def set_step
    @step = params[:step] || @steps.first
    Rails.logger.debug("Current step: #{@step}")
    
    if @steps.include?(@step)
      current_index = @steps.index(@step)
      @previous_step = current_index > 0 ? @steps[current_index - 1] : nil
    else
      @step = @steps.first  # or handle as needed
      @previous_step = nil
      Rails.logger.error("Invalid step parameter: #{params[:step]}. Defaulting to first step: #{@step}.")
    end
  end

  def render_step
    step_paths = {
      'profile' => 'employees/registrations/step-forms/edit_profile',
      'education' => 'employees/registrations/step-forms/edit_education',
      'work' => 'employees/registrations/step-forms/edit_work_experience',
      'skill' => 'employees/registrations/step-forms/edit_skills',
      'hobby' => 'employees/registrations/step-forms/edit_hobbies',
      'social_network' => 'employees/registrations/step-forms/edit_social_networks',
    }

    render step_paths[@step] || step_paths['profile']
  end
  
  def set_employee
    @employee = current_employee
  end

  def next_step
    next_step = @steps[@steps.index(@step) + 1]
    next_step.present? ? edit_employee_registration_path(step: next_step) : nil
  end
end
