require 'test_helper'

class ChatTest < ActiveSupport::TestCase
  def setup
    @chat = Chat.new(name: 'Test Conversation')
  end

  test 'chat is valid and can be saved' do
    assert @chat.valid?
    assert @chat.save
  end

  test 'chat has name of valid length' do
    invalid_names = ['', 'a' * 256]
    invalid_names.each do |invalid|
      @chat.name = invalid
      assert_not @chat.valid?, "#{invalid.inspect} should not be a valid chat name"
    end

    @chat.name = 'a' * 50
    assert @chat.valid?
  end
end
