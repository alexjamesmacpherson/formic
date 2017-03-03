class Tutor < ApplicationRecord
  belongs_to :tutor, :class_name => 'User'
  belongs_to :pupil, :class_name => 'User'

  # Record validation
  validates :tutor,
            presence: true,
            uniqueness: { scope: :pupil }
  validates :pupil,
            presence: true
  # Validate both users actually exist and are of correct user groups
  validate :users_correct_if_real?

private

  def users_correct_if_real?
    user_is_correct_if_real?(:tutor, self.tutor_id, 3)
    user_is_correct_if_real?(:pupil, self.pupil_id, 1)
  end
end
