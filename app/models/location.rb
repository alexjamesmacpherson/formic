class Location < ApplicationRecord
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
  # Validate location cannot be added to a non-existent school
  validate :school_exists?
end
