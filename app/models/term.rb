class Term < ApplicationRecord
  belongs_to :school

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  # Record validation
  validates :school,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :start_date, :end_date, :halfterm_start_date, :halfterm_end_date,
            presence: true
  # Validate term cannot be added to a non-existent school nor end before it starts
  validate :school_exists
  validate :term_cannot_end_before_start
  validate :half_cannot_end_before_start
  validate :halfterm_within_term

  def in_term?(date)
    (start_date..end_date).cover?(date)
  end

  def in_halfterm?(date)
    (halfterm_start_date..halfterm_end_date).cover?(date)
  end

private

  def school_exists
    unless School.exists?(school_id)
      errors.add(:school, 'must exist')
    end
  end

  def term_cannot_end_before_start
    return unless start_date && end_date

    if start_date > end_date
      errors.add(:end_date, 'cannot be before start of term')
    end
  end

  def half_cannot_end_before_start
    return unless halfterm_start_date && halfterm_end_date

    if halfterm_start_date > halfterm_end_date
      errors.add(:halfterm_end_date, 'cannot be before start of half term')
    end
  end

  def halfterm_within_term
    return unless start_date && halfterm_start_date && end_date && halfterm_end_date

    unless in_term?(halfterm_start_date)
      errors.add(:halfterm_start_date, 'cannot be before start of term')
    end

    unless in_term?(halfterm_end_date)
      errors.add(:halfterm_end_date, 'cannot be after end of term')
    end
  end
end
