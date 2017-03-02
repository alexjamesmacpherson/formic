class YearGroup < ApplicationRecord
  belongs_to :school
  has_many :users, dependent: :nullify
  has_many :subjects, dependent: :nullify

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  # Record validation
  validates :school,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  # Validate year group cannot be added to a non-existent school
  validate :school_exists

private

  def school_exists
    unless School.exists?(school_id)
      errors.add(:school, 'must exist')
    end
  end
end
