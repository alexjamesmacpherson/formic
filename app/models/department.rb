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
  validate :school_exists?
  # Validate head of department, if declared, is a real user
  validate :head_correct_if_real?

private

  def head_correct_if_real?
    user_is_correct_if_real?(:head, head_id, 3)
  end
end
