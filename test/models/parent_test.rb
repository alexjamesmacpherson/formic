require 'test_helper'

class ParentTest < ActiveSupport::TestCase
  def setup
    @child = users(:test_user)
    @parent = users(:test_parent)
    @relation = Parent.new(parent: @parent, child: @child)
  end

  test 'relation is valid and can be saved' do
    assert @relation.valid?
    assert @relation.save
  end

  test 'relation must have parent' do
    @relation.parent = nil
    assert_not @relation.valid?
  end

  test 'relation must have child' do
    @relation.child = nil
    assert_not @relation.valid?
  end

  test 'relation cannot be empty' do
    @relation.parent = nil
    @relation.child = nil
    assert_not @relation.valid?
  end

  test 'duplicate relations cannot exist' do
    @relation.save
    @duplicate = @relation.dup
    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'relation parent must have correct user group' do
    @parent.user_group = 1
    @parent.save
    assert_not @relation.valid?
    assert_not @relation.save
  end

  test 'relation child must have correct user group' do
    @child.user_group = 2
    @child.save
    assert_not @relation.valid?
    assert_not @relation.save
  end
end
