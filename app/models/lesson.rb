class Lesson < ApplicationRecord
  belongs_to :subject
  belongs_to :period
  belongs_to :location

  # Record validation
  # Can't have two lessons of the same subject at the same time (period)
  validates :subject,
            presence: true,
            uniqueness: { scope: :period }
  validates :period,
            presence: true
  # Can't have two lessons in the same place at the same time (period)
  validates :location,
            presence: true,
            uniqueness: { scope: :period }
  validate :subject_exists
  validate :period_exists
  validate :location_exists

private

  def subject_exists
    unless Subject.exists?(subject_id)
      errors.add(:subject, 'must exist')
    end
  end

  def period_exists
    unless Period.exists?(period_id)
      errors.add(:period, 'must exist')
    end
  end

  def location_exists
    unless Location.exists?(location_id)
      errors.add(:location, 'must exist')
    end
  end
end
