class Tutor < ApplicationRecord
  belongs_to :tutor, :class_name => 'User'
  belongs_to :pupil, :class_name => 'User'

  # Record validation
  validates :tutor,
            presence: true,
            uniqueness: { scope: :pupil }
  validates :pupil,
            presence: true
  # Validate both users actually exist
  validate :users_exist
  # Validate correct user groups
  validate :correct_user_group

private

  def users_exist
    unless User.exists?(tutor_id)
      errors.add(:tutor, 'must exist')
    end

    unless User.exists?(pupil_id)
      errors.add(:pupil, 'must exist')
    end
  end

  def correct_user_group
    if User.exists_but_not_group?(tutor_id, 3)
      errors.add(:tutor, 'must have correct user group')
    end

    if User.exists_but_not_group?(pupil_id, 1)
      errors.add(:pupil, 'must have correct user group')
    end
  end
end
