require "test_helper"

class NoticeMailerTest < ActionMailer::TestCase
  test "greeting" do
    mail = NoticeMailer.greeting
    assert_equal "Greeting", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
