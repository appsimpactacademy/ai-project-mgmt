# app/mailers/employee_mailer.rb
class EmployeeMailer < ApplicationMailer
  def send_csv(employee, csv_data, headers)
    @employee = employee
    debugger
    attachments["#{headers.downcase.pluralize}-#{Date.today}.csv"] = { mime_type: 'text/csv', content: csv_data }
    mail(to: @employee.email, subject: "#{headers.downcase.pluralize} CSV Export")
  end
end
