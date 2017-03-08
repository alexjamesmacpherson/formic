require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  def setup
    @user = users(:test_user)
    @notification = @user.notifications.create(title: 'Test Notification', message: 'This is a new notification', link: 'http://localhost:3000/')
  end

  test 'notification is valid' do
    assert @notification.valid?
  end

  test 'notification must have user' do
    @notification.user = nil
    assert_not @notification.valid?
  end

  test 'notification cannot have non-existent user' do
    assert User.exists?(@notification.user_id)
    assert_not User.exists?(10)

    @notification.user_id = 10
    assert_not @notification.valid?
  end

  test 'notification still valid if seen' do
    @notification.seen = true
    assert @notification.valid?
  end

  test 'notification has title of valid length' do
    invalid_titles = [nil, '', 'a' * 256, 'a' * 1000]
    invalid_titles.each do |invalid|
      @notification.title = invalid
      assert_not @notification.valid?, "#{invalid.inspect} should not be a valid notification"
    end

    valid_titles = ['a', 'a' * 50, 'a' * 255,]
    valid_titles.each do |valid|
      @notification.title = valid
      assert @notification.valid?, "#{valid.inspect} should be a valid notification"
    end
  end

  test 'notification has message of valid length' do
    invalid_messages = [nil, '', 'a' * 256, 'a' * 1000]
    invalid_messages.each do |invalid|
      @notification.message = invalid
      assert_not @notification.valid?, "#{invalid.inspect} should not be a valid notification"
    end
    
    valid_messages = ['a', 'a' * 50, 'a' * 255,]
    valid_messages.each do |valid|
      @notification.message = valid
      assert @notification.valid?, "#{valid.inspect} should be a valid notification"
    end
  end

  test 'notification has link of valid length' do
    invalid_links = ['a' * 256, 'a' * 1000]
    invalid_links.each do |invalid|
      @notification.link = invalid
      assert_not @notification.valid?, "#{invalid.inspect} should not be a valid notification link"
    end

    valid_links = [nil, '', 'a', 'a' * 50, 'a' * 255,]
    valid_links.each do |valid|
      @notification.link = valid
      assert @notification.valid?, "#{valid.inspect} should be a valid notification link"
    end
  end
end
