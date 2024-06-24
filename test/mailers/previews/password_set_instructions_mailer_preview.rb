# Preview all emails at http://localhost:3000/rails/mailers/password_set_instructions_mailer
class PasswordSetInstructionsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/password_set_instructions_mailer/setup_password_for_employee
  def setup_password_for_employee
    PasswordSetInstructionsMailer.setup_password_for_employee
  end

end
