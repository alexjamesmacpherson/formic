class Tutor < ApplicationRecord
  belongs_to :tutor, :class_name => 'User'
  belongs_to :pupil, :class_name => 'User'

  # Record validation
  validates :tutor,
            presence: true,
            uniqueness: { scope: :pupil }
  validates :pupil,
            presence: true
  # Validate correct user groups
  validate :correct_user_group

private

  def correct_user_group
    if self.tutor_id != nil && User.find(self.tutor_id).user_group != 3
      errors.add(:tutor, 'must have correct user group')
    elsif self.pupil_id != nil && User.find(self.pupil_id).user_group != 1
      errors.add(:pupil, 'must have correct user group')
    end
  end
end
