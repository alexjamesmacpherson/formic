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
  validate :head_exists_and_teacher?

private

  def school_exists
    unless School.exists?(school_id)
      errors.add(:school, 'must exist')
    end
  end

  def head_exists_and_teacher?
    if User.id_but_nonexistent?(head_id)
      errors.add(:head, 'must exist')
    elsif User.exists_but_not_group?(head_id, 3)
      errors.add(:head, 'must be a teacher')
    end
  end
end
