class Assignment < ApplicationRecord
  belongs_to :subject
  has_many :submissions, dependent: :destroy

  # Remove whitespace
  auto_strip_attributes :name, :information, :squish => true

  # Record validation
  validates :subject,
            presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :information,
            presence: true,
            allow_blank: true
  validates :due,
            presence: true
  # Validate assignment cannot be added to a non-existent subject
  validate :subject_exists

  private

  def subject_exists
    unless Subject.exists?(subject_id)
      errors.add(:subject, 'must exist')
    end
  end
end
