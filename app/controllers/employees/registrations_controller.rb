# frozen_string_literal: true

class Employees::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # Update without requiring the current password
    if update_resource(resource, account_update_params)
      set_flash_message :notice, :updated if is_navigational_format?
      bypass_sign_in resource, scope: resource_name
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords resource
      render "edit"
    end
  end


  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :contact_number, :job_title])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, 
      :last_name, 
      :email, 
      :contact_number, 
      :job_title, 
      :password, 
      :password_confirmation, 
      :current_password,
      education_records_attributes: [:id, :course_name, :start_year, :end_year, :marks, :is_pursuing, :college_or_university, :_destroy],
      work_experiences_attributes: [:id, :job_title, :role, :description, :company_name, :start_date, :end_date, :is_currently_working_here, :_destroy]
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [hobby_ids: [], skill_ids: []])
  end

  def update_resource(resource, params)
    # Skip current password requirement
    resource.update_without_password(params)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
