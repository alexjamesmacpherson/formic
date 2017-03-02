class Period < ApplicationRecord
  belongs_to :school

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  # Record validation
  validates :school,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :starts_at, :ends_at,
            presence: true
  # Validate period cannot be added to a non-existent school nor end before it starts
  validate :school_exists
  validate :cannot_end_before_start

  private

  def school_exists
    unless School.exists?(school_id)
      errors.add(:school, 'must exist')
    end
  end

  def cannot_end_before_start
    return unless starts_at && ends_at

    if starts_at > ends_at
      errors.add(:ends_at, 'cannot be before start of period')
    end
  end
end
