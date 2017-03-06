require 'test_helper'

class ChatTest < ActiveSupport::TestCase
  def setup
    @pupil = users(:test_user)
    @tutor = users(:test_teacher)

    @chat = Chat.new(name: 'Test Conversation')
    @chat.converses.new(user: @pupil)
    @chat.converses.new(user: @tutor)
    @chat.save
  end

  test 'chat is valid' do
    assert @chat.valid?
  end

  test 'chat has name of valid length' do
    invalid_names = ['a' * 256]
    invalid_names.each do |invalid|
      @chat.name = invalid
      assert_not @chat.valid?, "#{invalid.inspect} should not be a valid chat name"
    end

    @chat.name = 'a' * 50
    assert @chat.valid?
  end

  test 'chat cannot have fewer than 2 users post-creation' do
    assert_equal 2, @chat.converses.length
    assert_difference 'Converse.count', -1 do
      @chat.converses.first.destroy
    end
    # Ideally need a function to flush all invalidated records from database, but this will be very slow given validation time
    assert_not @chat.reload.valid?
  end
end
