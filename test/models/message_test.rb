require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @chat = chats(:one)
    @sender = @chat.users.first
    @invalid_sender = users(:test_admin)

    @message = @chat.messages.new(sender: @sender, text: 'This is a test message!')
    @message.save
  end

  test 'message is valid and can be saved' do
    assert @message.valid?
    assert @message.save
  end

  test 'message must belong to chat' do
    @message.chat = nil
    assert_not @message.valid?
  end

  test 'message must be sent by user' do
    @message.sender = nil
    assert_not @message.valid?
  end

  test 'message text can be of any length but cannot be blank' do
    invalid_messages = [nil, '']
    invalid_messages.each do |message|
      @message.text = message
      assert_not @message.valid?, "#{message.inspect} should not be a valid message"
    end

    valid_messages = ['a', 'a' * 50, 'a' * 255, 'a' * 1000]
    valid_messages.each do |message|
      @message.text = message
      assert @message.valid?, "#{message.inspect} should be a valid message"
    end
  end

  test 'message cannot have non-existent chat' do
    assert Chat.exists?(@message.chat_id)
    assert_not Chat.exists?(10)

    @message.chat_id = 10
    assert_not @message.valid?
  end

  test 'message cannot have non-existent sender' do
    assert User.exists?(@message.sender_id)
    assert_not User.exists?(10)

    @message.sender_id = 10
    assert_not @message.valid?
  end

  test 'message cannot be sent by user outside of chat group' do
    @message.sender = @invalid_sender
    assert_not @message.chat.users.include?(@invalid_sender)
    assert_not @message.valid?
  end

  test 'message is destroyed with chat' do
    assert_difference 'Message.count', -1 do
      @chat.destroy!
    end
  end

  test 'message is destroyed with sender' do
    assert_difference 'Message.count', -1 do
      @sender.destroy!
    end
  end

  test 'message sent_at stamp is creation time' do
    assert_equal @message.created_at, @message.sent_at
  end
end
