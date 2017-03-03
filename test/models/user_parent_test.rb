require 'test_helper'

class UserParentTest < ActiveSupport::TestCase
  def setup
    @child = users(:test_user)
    @parent = users(:test_parent)
    @relation = ParentRelation.new(parent: @parent, child: @child)
  end

  test 'relation is valid and can be saved' do
    assert @relation.valid?
    assert @relation.save
  end

  test 'child can get parents and parent can get children' do
    assert @relation.save
    assert_equal @child, @parent.children.last
    assert_equal @parent, @child.parents.last
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
    @duplicate = @relation.dup
    @relation.save
    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'relation parent must have correct user group' do
    @parent.update_attribute(:group, 1)
    assert_not @relation.valid?
    assert_not @relation.save
  end

  test 'relation child must have correct user group' do
    @child.update_attribute(:group, 2)
    assert_not @relation.valid?
    assert_not @relation.save
  end

  test 'relation cannot have non-existent child' do
    assert User.exists?(@relation.child_id)
    assert_not User.exists?(10)

    @relation.child_id = 10
    assert_not @relation.valid?
  end

  test 'relation cannot have non-existent parent' do
    assert User.exists?(@relation.parent_id)
    assert_not User.exists?(10)

    @relation.parent_id = 10
    assert_not @relation.valid?
  end
end
