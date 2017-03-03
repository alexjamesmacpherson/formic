class Teach < ApplicationRecord
  belongs_to :subject
  belongs_to :teacher, :class_name => 'User'

  # Record validation
  validates :subject,
            presence: true,
            uniqueness: { scope: :teacher }
  validates :teacher,
            presence: true
  # Validate existence and further correctness
  validate :subject_exists
  validate :user_exists_and_teacher?

  private

  def subject_exists
    unless Subject.exists?(subject_id)
      errors.add(:subject, 'must exist')
    end
  end

  def user_exists_and_teacher?
    if !User.exists?(teacher_id)
      errors.add(:teacher, 'must exist')
    elsif User.exists_but_not_group?(teacher_id, 3)
      errors.add(:teacher, 'must have correct user group')
    end
  end
end
