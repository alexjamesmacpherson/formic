require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @user = users(:test_admin)
  end

  test 'page title can be defined by method' do
    assert_equal 'Formic Learning', full_title
    assert_equal 'Test | Formic Learning', full_title('Test')
  end

  test 'grade can be determined by score' do
    assert_equal 'A*', score_to_grade(100)
    assert_equal 'A*', score_to_grade(95)
    assert_equal 'A', score_to_grade(85)
    assert_equal 'B', score_to_grade(75)
    assert_equal 'C', score_to_grade(65)
    assert_equal 'D', score_to_grade(55)
    assert_equal 'E', score_to_grade(45)
    assert_equal 'F', score_to_grade(35)
    assert_equal 'U', score_to_grade(20)
    assert_equal 'X', score_to_grade(5)
  end

  test 'notification can be pushed to given user and is correct' do
    assert_difference 'Notification.count', 1 do
      notify(@user, 'Test Notification', 'Notification Body', 'http://localhost:3000/')
    end

    assert_equal 'Test Notification', Notification.last.title
    assert_equal 'Notification Body', Notification.last.message
    assert_equal 'http://localhost:3000/', Notification.last.link
    assert_equal @user, Notification.last.user
  end

  test 'pretty count helper returns "9+" for any number over 9' do
    (0..9).each do |n|
      assert_equal n, pretty_count(n)
    end

    numbers = [10, 15, 100]
    numbers.each do |n|
      assert_equal '9+', pretty_count(n)
    end
  end

  test 'function returns correct related user type' do
    @user.group = 1
    assert_equal 'Tutor', related_user_type('Teacher')
    assert_equal 'Parent', related_user_type('Parent')

    @user.group = 2
    assert_equal 'Tutor of Child', related_user_type('Teacher')
    assert_equal 'Parent', related_user_type('Parent')

    assert_equal 'Child', related_user_type('Student')
    assert_equal 'Parent', related_user_type('Parent')

    @user.group = 3
    assert_equal 'Tutee', related_user_type('Student')
    assert_equal 'Parent', related_user_type('Parent')

    @user.group = 4
    assert_equal 'Tutor', related_user_type('Tutor')
  end
end