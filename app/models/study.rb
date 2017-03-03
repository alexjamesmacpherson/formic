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
  validate :subject_exists?
  validate :pupil_correct_and_real?
  validate :percentage_grades?

private

  def pupil_correct_and_real?
    user_is_correct_and_real?(:pupil, self.pupil_id, 1)
  end

  def percentage_grades?
    grade_percentage?(:target, self.target)
    grade_percentage?(:expected, self.expected)
  end
end
