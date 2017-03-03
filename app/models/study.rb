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
  # Validate existence and further correctness
  validate :subject_exists
  validate :pupil_exists_and_student?
  validate :grades_percentages?

private

  def subject_exists
    unless Subject.exists?(subject_id)
      errors.add(:subject, 'must exist')
    end
  end

  def pupil_exists_and_student?
    if !User.exists?(pupil_id)
      errors.add(:pupil, 'must exist')
    elsif User.exists_but_not_group?(pupil_id, 1)
      errors.add(:pupil, 'must have correct user group')
    end
  end

  def grades_percentages?
    grade_percentage?(:target, target)
    grade_percentage?(:expected, expected)
  end

  def grade_percentage?(attr, grade)
    if grade && !(0..100).include?(grade)
      errors.add(:attr, 'must be a percentage between 0-100%')
    end
  end
end
