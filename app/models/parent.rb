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
  validate :users_correct_and_real?

private

  def users_correct_and_real?
    user_is_correct_and_real?(:parent, self.parent_id, 2)
    user_is_correct_and_real?(:child, self.child_id, 1)
  end
end
