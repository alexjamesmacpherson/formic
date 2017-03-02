class Department < ApplicationRecord
  belongs_to :school
  belongs_to :head, :class_name => 'User'
  has_many :subjects, dependent: :destroy

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  # Record validation
  validates :school,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :head,
            presence: true,
            allow_nil: true
  # Validate department cannot be added to a non-existent school
  validate :school_exists
  validate :head_exists
  validate :head_is_teacher

private

  def school_exists
    unless School.exists?(school_id)
      errors.add(:school, 'must exist')
    end
  end

  def head_exists
    if head_id && !User.exists?(head_id)
      errors.add(:head, 'must exist')
    end
  end

  def head_is_teacher
    if User.exists?(head_id) && !User.find(head_id).is?(:group, 3)
      errors.add(:head, 'must be a teacher')
    end
  end
end
