require "test_helper"

class PasswordSetInstructionsMailerTest < ActionMailer::TestCase
  test "setup_password_for_employee" do
    mail = PasswordSetInstructionsMailer.setup_password_for_employee
    assert_equal "Setup password for employee", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
