class Study < ApplicationRecord
  belongs_to :subject
  belongs_to :pupil, :class_name => 'User'

  # Record validation
  validates :subject,
            presence: true,
            uniqueness: { scope: :pupil }
  validates :pupil,
            presence: true
  validates :challenge_grade,
            presence: true
  # Validate existence and further correctness
  validate :subject_exists?
  validate :pupil_correct_if_real?
  validates_inclusion_of :challenge_grade, in: ('A'..'F').to_a

private

  def pupil_correct_if_real?
    user_is_correct_if_real?(:pupil, pupil_id, 1)
  end
end
