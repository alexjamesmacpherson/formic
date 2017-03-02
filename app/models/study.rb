class Study < ApplicationRecord
  belongs_to :subject
  belongs_to :pupil, :class_name => 'User'

  # Record validation
  validates :subject,
            presence: true,
            uniqueness: { scope: :pupil }
  validates :pupil,
            presence: true
  validates :target,
            presence: true,
            allow_nil: true
  validates :expected,
            presence: true,
            allow_nil: true
  # Validate both users actually exist
  validate :subject_exists
  validate :pupil_exists
  # Validate correct user group
  validate :user_is_student
  validate :grade_percentage

  private

  def subject_exists
    if subject_id && !Subject.exists?(subject_id)
      errors.add(:subject, 'must exist')
    end
  end

  def pupil_exists
    if pupil_id && !User.exists?(pupil_id)
      errors.add(:pupil, 'must exist')
    end
  end

  def user_is_student
    if pupil_id && User.exists?(pupil_id) && !User.find(pupil_id).is?(:group, 1)
      errors.add(:pupil, 'must have correct user group')
    end
  end

  def grade_percentage
    if expected && !(0 <= expected && expected <= 100)
      errors.add(:expected, 'must be a percentage between 0-100%')
    end

    if target && !(0 <= target && target <= 100)
      errors.add(:target, 'must be a percentage between 0-100%')
    end
  end
end
