class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :pupil, :class_name => 'User'
  belongs_to :marker, :class_name => 'User'

  # Remove whitespace
  auto_strip_attributes :feedback, :convert_non_breaking_spaces => true

  # Record validation
  validates :assignment,
            presence: true,
            uniqueness: { scope: :pupil }
  validates :pupil,
            presence: true
  validates :file,
            presence: true,
            length: { maximum: 255 },
            if: :submitted?
  validates :submitted_at,
            presence: true,
            if: :submitted?
  validates :marker, :marked_at,
            presence: true,
            if: :marked?
  validates :feedback,
            presence: true,
            allow_blank: true,
            if: :marked?
  validates :grade,
            presence: true,
            if: :marked?
  validate :pupil_exists
  validate :pupil_is_student
  validate :marker_exists
  validate :marker_is_teacher
  validate :grade_percentage

  def submitted?
    submitted
  end

  def marked?
    marked
  end

private

  def pupil_exists
    unless User.exists?(pupil_id)
      errors.add(:pupil, 'must exist')
    end
  end

  def pupil_is_student
    if User.exists_but_not_group?(pupil_id, 1)
      errors.add(:pupil, 'must have correct user group')
    end
  end

  def marker_exists
    if marker_id && !User.exists?(marker_id)
      errors.add(:marker, 'must exist')
    end
  end

  def marker_is_teacher
    if User.exists_but_not_group?(marker_id, 3)
      errors.add(:marker, 'must have correct user group')
    end
  end

  def grade_percentage
    if grade && !(0..100).include?(grade)
      errors.add(:grade, 'must be a percentage between 0-100%')
    end
  end
end
