class Parent < ApplicationRecord
  belongs_to :parent, :class_name => 'User'
  belongs_to :child, :class_name => 'User'

  # Record validation
  validates :parent,
            presence: true,
            uniqueness: { scope: :child }
  validates :child,
            presence: true
  # Validate both users actually exist
  validate :users_exist
  # Validate correct user groups
  validate :correct_user_group

private

  def users_exist
    unless User.exists?(parent_id)
      errors.add(:parent, 'must exist')
    end

    unless User.exists?(child_id)
      errors.add(:child, 'must exist')
    end
  end

  def correct_user_group
    if User.exists?(parent_id) && !User.find(parent_id).is?(:group, 2)
      errors.add(:parent, 'must have correct user group')
    end

    if User.exists?(child_id) && !User.find(child_id).is?(:group, 1)
      errors.add(:child, 'must have correct user group')
    end
  end
end
