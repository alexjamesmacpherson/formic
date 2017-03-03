require 'test_helper'

class UnreadMessageTest < ActiveSupport::TestCase
  def setup
    @chat = chats(:one)
    @sender = @chat.users.first
    @recipient = @chat.users.last
    @invalid_recipient = users(:test_admin)

    @message = @chat.messages.create(sender: @sender, text: 'This is a test message!')
    @unread = @message.unread_messages.last
  end

  test 'unread messages are valid' do
    @message.unread_messages.each do |m|
      assert m.valid?
    end
  end

  test 'unread message is created by sending a message' do
    assert_difference 'UnreadMessage.count', 1 do
      @chat.messages.create(sender: @sender, text: 'This is another test message!')
    end
  end

  test 'unread message is sent to all other users in chat automatically' do
    assert_equal @recipient, @unread.recipient
  end

  test 'unread message must belong to message' do
    @unread.message = nil
    assert_not @unread.valid?
  end

  test 'unread message must be posted to user' do
    @unread.recipient = nil
    assert_not @unread.valid?
  end

  test 'unread message cannot have non-existent message' do
    assert Message.exists?(@unread.message_id)
    assert_not Message.exists?(10)

    @unread.message_id = 10
    assert_not @unread.valid?
  end

  test 'unread message cannot have non-existent recipient' do
    assert User.exists?(@unread.recipient_id)
    assert_not User.exists?(10)

    @unread.recipient_id = 10
    assert_not @unread.valid?
  end

  test 'unread message cannot be sent to user outside of chat group' do
    @unread.recipient = @invalid_recipient
    assert_not @message.chat.users.include?(@invalid_recipient)
    assert_not @unread.valid?
  end

  test 'unread message is destroyed with message' do
    assert_difference 'UnreadMessage.count', -1 do
      @message.destroy!
    end
  end

  test 'message is destroyed with sender' do
    assert_difference 'UnreadMessage.count', -1 do
      @recipient.destroy!
    end
  end

  test 'reading chat clears all unread message notifications for only that user' do
    # Add third user to chat
    @chat.converses.create(user: @invalid_recipient)
    assert_equal 1, UnreadMessage.count

    # Sending 5 messages fires 10 unread message notifications, 5 to each other user
    assert_difference 'UnreadMessage.count', 10 do
      5.times do |n|
        @chat.messages.create(sender: @sender, text: "New message #{n}.")
      end
    end

    # Reading chat as original user removes 6 notifications (there was already one, total currently 11)
    assert_difference 'UnreadMessage.count', -6 do
      @chat.read_all_for(@recipient)
    end

    # Recipient has now read chat
    assert @chat.read_by?(@recipient)

    # Only remaining unread messages should be for other user
    assert_equal @chat.unread_messages.count, @chat.unread_count_for(@invalid_recipient)
  end
end
