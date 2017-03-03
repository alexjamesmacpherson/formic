require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  def setup
    @user = users(:test_user)
    @notification = @user.notifications.create(message: 'Test Notification', link: 'http://localhost:3000/')
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

  test 'max 20 notifications stored per user' do
    assert_equal 1, @user.notifications.count

    assert_difference 'Notification.count', 19 do
      19.times do |n|
        @user.notifications.create(message: "Notification #{n + 1}", link: '')
      end
    end

    assert_equal 20, @user.notifications.count
    assert_equal 'Test Notification', Notification.where(user_id: @user.id).order(:created_at).first.message

    @user.notifications.create(message: "Notification 20", link: '')
    assert_equal 'Notification 1', Notification.where(user_id: @user.id).order(:created_at).first.message
    assert_equal 'Notification 20', Notification.where(user_id: @user.id).order(:created_at).last.message
  end
end
