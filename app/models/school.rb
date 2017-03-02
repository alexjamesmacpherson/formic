class School < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :departments, dependent: :destroy
  has_many :year_groups, dependent: :destroy
  has_many :periods, dependent: :destroy
  has_many :terms, dependent: :destroy

  # Remove whitespace
  auto_strip_attributes :name, :motto, :phone, :squish => true
  auto_strip_attributes :address, :convert_non_breaking_spaces => true

  # Cleanse address to add commas to ends of line if they don't already exist
  before_save :cleanse_address

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

private

  def cleanse_address
    if address
      addr = ''
      address.each_line do |line|
        unless line.blank?
          line.gsub!(/(^[ ]+)|([ ]+$)/, '')
          line.gsub!(/([ ]*\r$)/, "\r")
          if /,\r$/.match(line)
            addr += line.gsub(/(^[ ]+)|([ ]+$)/, '').gsub(/([ ]*,\r$)/, ",\r")
          else
            addr += line.gsub(/(^[ ]+)/, '').gsub(/[ ]*\r/, ",\r")
          end
        end
      end
      self.address = addr
    end
  end
end
