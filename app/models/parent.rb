class Parent < ApplicationRecord
  belongs_to :parent, :class_name => 'User'
  belongs_to :child, :class_name => 'User'

  # Record validation
  validates :parent,
            presence: true,
            uniqueness: { scope: :child }
  validates :child,
            presence: true
  # Validate correct user groups
  validate :correct_user_group

private

  def correct_user_group
    if parent_id && !User.find(parent_id).group?(2)
      errors.add(:parent, 'must have correct user group')
    elsif child_id && !User.find(child_id).group?(1)
      errors.add(:child, 'must have correct user group')
    end
  end
end
