require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = users(:test_user)
    school = School.find(user.school_id)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)

    assert_equal 'Activate Your Formic Learning Account!', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@formic.herokuapp.com'], mail.from

    assert_match user.name, mail.body.encoded
    assert_match school.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end
end
