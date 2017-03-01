class School < ApplicationRecord
  has_many :users, dependent: :destroy

  # Remove whitespace
  auto_strip_attributes :name, :motto, :phone, :squish => true
  auto_strip_attributes :address, :convert_non_breaking_spaces => true

  # Record validation
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :address,
            presence: true
  # Regular expression matches numbers of form XXXXX XXXXXX | (+XX?X?)? (X)? XXXX XXXXXX - brackets, hyphens, slashes and spaces optional
  # Weak validation - basically ensures roughly correct length and only valid character entry
  VALID_PHONE_NUMBER_REGEX = /\A(([ \-()\/]?\d[ \-()\/]?){11}|([ \-()\/]?\+[ \-()\/]?)([ \-()\/]?\d[ \-()\/]?){1,3}([ ])?([ \-()\/]?\d[ \-()\/]?){10,11})\z/i
  validates :phone,
            presence: true,
            format: { with: VALID_PHONE_NUMBER_REGEX }
  validates :motto,
            length: { maximum: 255 }
end
