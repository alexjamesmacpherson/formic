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
  validate :users_exist_and_correct?

private

  def users_exist_and_correct?
    is_correct_and_real?(:tutor, tutor_id, 3)
    is_correct_and_real?(:pupil, pupil_id, 1)
  end

  def is_correct_and_real?(attr, id, group)
    if !User.exists?(id)
      errors.add(attr, 'must exist')
    elsif User.exists_but_not_group?(id, group)
      errors.add(attr, 'must have correct user group')
    end
  end
end
