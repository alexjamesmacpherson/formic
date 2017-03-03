class Period < ApplicationRecord
  belongs_to :school
  has_many :lessons, dependent: :destroy

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  # Record validation
  validates :school,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  # Start/end must also contain day as well as time
  validates :starts, :ends,
            presence: true
  # Validate period cannot be added to a non-existent school nor end before it starts
  validate :school_exists?
  validate :period_ends_before_start?

private

  def period_ends_before_start?
    ends_before_start?(:ends, starts, ends)
  end
end
