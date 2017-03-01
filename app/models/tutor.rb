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
    if tutor_id && !User.find(tutor_id).group?(3)
      errors.add(:tutor, 'must have correct user group')
    elsif pupil_id && !User.find(pupil_id).group?(1)
      errors.add(:pupil, 'must have correct user group')
    end
  end
end
