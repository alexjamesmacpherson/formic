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
    if self.parent_id != nil && User.find(self.parent_id).user_group != 2
      errors.add(:parent, 'must have correct user group')
    elsif self.child_id != nil && User.find(self.child_id).user_group != 1
      errors.add(:child, 'must have correct user group')
    end
  end
end
