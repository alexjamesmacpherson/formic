class Lesson < ApplicationRecord
  belongs_to :subject
  #belongs_to :period
  belongs_to :location

  # Record validation
  # Can't have two lessons of the same subject at the same time (period)
  validates :subject,
            presence: true,
            uniqueness: { scope: :start_time }
  #validates :period,
            #presence: true
  # Can't have two lessons in the same place at the same time (period)
  validates :location,
            presence: true,
            uniqueness: { scope: :start_time }
  # Validate all records exist within the database if declared
  validate :subject_exists?
  #validate :period_exists?
  validate :location_exists?

private

  def location_exists?
    is_record?(:location, Location, location_id)
  end
end
