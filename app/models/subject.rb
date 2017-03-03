class Subject < ApplicationRecord
  belongs_to :department
  belongs_to :year_group

  has_many :studies, dependent: :destroy
  has_many :pupils, through: :studies

  has_many :teaches, dependent: :destroy
  has_many :teachers, through: :teaches

  has_many :assignments, dependent: :destroy
  has_many :lessons, dependent: :destroy

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  # Record validation
  validates :department,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  # Validate subject cannot be added to a non-existent department or year group
  validate :department_exists?
  validate :year_group_exists?
end
