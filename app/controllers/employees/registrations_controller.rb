# frozen_string_literal: true

class Employees::RegistrationsController < Devise::RegistrationsController
  layout 'application'
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :set_template, only: [:preview_template, :get_resume]

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if update_resource(resource, account_update_params)
      set_flash_message :notice, :updated if is_navigational_format?
      bypass_sign_in resource, scope: resource_name
      redirect_to employee_detail_path(resource.id)
    else
      clean_up_passwords resource
      flash[:alert] = resource.errors.full_messages.join(', ')
      redirect_to edit_employee_registration_path
    end
  end

  def employee_detail
    @employee = Employee.find(params[:id])
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
    # @template is already set by the before_action
  end

  def get_resume
    @employee = current_employee
    @template_identifier = @template.name.downcase
  end

  protected

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
      :password, 
      :password_confirmation,
      education_records_attributes: [:id, :course_name, :start_year, :end_year, :marks, :is_pursuing, :college_or_university, :_destroy],
      work_experiences_attributes: [:id, :job_title, :role, :description, :company_name, :start_date, :end_date, :is_currently_working_here, :_destroy]
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [hobby_ids: [], skill_ids: []])
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    resource.developer? ? admin_employees_path : super
  end

  private

  def set_template
    @template = Template.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Template not found."
    redirect_to some_path # Adjust to your desired path
  end
end
