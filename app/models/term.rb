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
  validates :starts, :ends, :halfterm_starts, :halfterm_ends,
            presence: true
  # Validate term cannot be added to a non-existent school nor end before it starts
  validate :school_exists?
  validate :term_ends_before_start?
  validate :half_term_ends_before_start?
  validate :halfterm_within_term

  def in_term?(date)
    if starts && ends && date
      (starts..ends).cover?(date)
    else
      false
    end
  end

  def in_halfterm?(date)
    (halfterm_starts..halfterm_ends).cover?(date)
  end

private

  def term_ends_before_start?
    ends_before_start?(:ends, starts, ends)
  end

  def half_term_ends_before_start?
    ends_before_start?(:halfterm_ends, halfterm_starts, halfterm_ends)
  end

  def halfterm_within_term
    unless in_term?(halfterm_starts)
      errors.add(:halfterm_starts, 'cannot be before start of term')
    end

    unless in_term?(halfterm_ends)
      errors.add(:halfterm_ends, 'cannot be after end of term')
    end
  end
end
