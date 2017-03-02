class Teach < ApplicationRecord
  belongs_to :subject
  belongs_to :teacher, :class_name => 'User'

  # Record validation
  validates :subject,
            presence: true,
            uniqueness: { scope: :teacher }
  validates :teacher,
            presence: true
  # Validate both users actually exist
  validate :subject_exists
  validate :teacher_exists
  # Validate correct user group
  validate :user_is_teacher

  private

  def subject_exists
    unless Subject.exists?(subject_id)
      errors.add(:subject, 'must exist')
    end
  end

  def teacher_exists
    unless User.exists?(teacher_id)
      errors.add(:teacher, 'must exist')
    end
  end

  def user_is_teacher
    if User.exists?(teacher_id) && !User.find(teacher_id).is?(:group, 3)
      errors.add(:teacher, 'must have correct user group')
    end
  end
end
