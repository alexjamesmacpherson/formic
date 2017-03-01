class Subject < ApplicationRecord
  belongs_to :department

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  # Record validation
  validates :department,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  # Validate subject cannot be added to a non-existent department
  validate :department_exists

private

  def department_exists
    if department_id && !Department.exists?(department_id)
      errors.add(:department, 'must exist')
    end
  end
end
