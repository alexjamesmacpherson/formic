require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'page title can be defined by method' do
    assert_equal 'Formic Learning', full_title
    assert_equal 'Test | Formic Learning', full_title('Test')
  end

  test 'grade can be determined by score' do
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
end