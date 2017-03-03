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
  validate :subject_exists?
  validate :teacher_correct_if_real?

private

  def teacher_correct_if_real?
    user_is_correct_if_real?(:teacher, self.teacher_id, 3)
  end
end
