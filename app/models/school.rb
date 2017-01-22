class School < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :address,
            presence: true
  # Regular expression matches numbers of form +XX XXXX XXXXXX | +XX XXXXX XXXXXX | XXXXX XXXXXX
  # Whitespaces are optional but cannot exceed a single space
  VALID_PHONE_NUMBER_REGEX = /\A(\+\d{2}\s?\d?\d{4}|\d{5})\s?\d{6}\z/i
  validates :phone_number,
            presence: true,
            format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :motto,
            length: { maximum: 255 }
end
