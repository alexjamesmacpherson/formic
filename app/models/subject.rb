class Subject < ApplicationRecord
  belongs_to :department
  belongs_to :year_group

  has_many :studies, dependent: :destroy
  has_many :pupils, through: :studies

  has_many :teaches, dependent: :destroy
  has_many :teachers, through: :teaches

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  # Record validation
  validates :department,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  # Validate subject cannot be added to a non-existent department or year group
  validate :department_exists
  validate :year_group_exists

private

  def department_exists
    if department_id && !Department.exists?(department_id)
      errors.add(:department, 'must exist')
    end
  end

  def year_group_exists
    if year_group_id && !YearGroup.exists?(year_group_id)
      errors.add(:year_group, 'must exist')
    end
  end
end
