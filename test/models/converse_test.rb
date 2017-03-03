require 'test_helper'

class ConverseTest < ActiveSupport::TestCase
  def setup
    @chat = chats(:two)
    @pupil = users(:test_user)
    @tutor = users(:test_teacher)

    @relation = @chat.converses.new(chat: @chat, user: @pupil)
    @relation.save
  end

  test 'relation is valid and can be saved' do
    assert @relation.valid?
    assert @relation.save
  end

  test 'chat can fetch users and user can get chats' do
    assert @relation.save
    assert_equal @pupil, @chat.users.first
    assert_equal @chat, @pupil.chats.first
  end

  test 'duplicate relations cannot exist' do
    @duplicate = @relation.dup
    @relation.save
    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'relation must have user' do
    @relation.user = nil
    assert_not @relation.valid?
  end

  test 'relation must have chat' do
    @relation.chat = nil
    assert_not @relation.valid?
  end

  test 'relation cannot be empty' do
    @relation.user = nil
    @relation.chat = nil
    assert_not @relation.valid?
  end

  test 'relation cannot have non-existent user' do
    assert User.exists?(@relation.user_id)
    assert_not User.exists?(10)

    @relation.user_id = 10
    assert_not @relation.valid?
  end

  test 'relation cannot have non-existent chat' do
    assert Chat.exists?(@relation.chat_id)
    assert_not Chat.exists?(10)

    @relation.chat_id = 10
    assert_not @relation.valid?
  end

  test 'relation is destroyed with chat' do
    assert_difference 'Converse.count', -1 do
      @chat.destroy!
    end
    assert_not @relation.valid?
  end

  test 'relation is destroyed with user' do
    # -2 because pupil has another relation setup in the fixtures...
    assert_difference 'Converse.count', -2 do
      @pupil.destroy!
    end
    assert_not @relation.valid?
  end
end
