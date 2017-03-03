class Parent < ApplicationRecord
  belongs_to :parent, :class_name => 'User'
  belongs_to :child, :class_name => 'User'

  # Record validation
  validates :parent,
            presence: true,
            uniqueness: { scope: :child }
  validates :child,
            presence: true
  # Validate both users actually exist and are of correct user groups
  validate :users_exist_and_correct?

private

  def users_exist_and_correct?
    is_correct_and_real?(:parent, parent_id, 2)
    is_correct_and_real?(:child, child_id, 1)
  end

  def is_correct_and_real?(attr, id, group)
    if !User.exists?(id)
      errors.add(attr, 'must exist')
    elsif User.exists_but_not_group?(id, group)
      errors.add(attr, 'must have correct user group')
    end
  end
end
