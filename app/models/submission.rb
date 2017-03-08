class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :pupil, :class_name => 'User'
  belongs_to :marker, :class_name => 'User'

  # Mount avatar uploader
  mount_uploader :file, FileUploader

  # Remove whitespace
  auto_strip_attributes :feedback, :convert_non_breaking_spaces => true

  # Record validation
  validates :assignment,
            presence: true,
            uniqueness: { scope: :pupil }
  validates :pupil,
            presence: true
  validates :file,
            presence: true,
            if: :submitted?
  validates :submitted_at,
            presence: true,
            if: :submitted?
  validates :marker, :marked_at,
            presence: true,
            if: :marked?
  validates :feedback,
            presence: true,
            allow_blank: true,
            if: :marked?
  validates :grade,
            presence: true,
            inclusion: -2..2,
            if: :marked?
  validate :users_correct_if_real?

  def submitted?
    submitted
  end

  def marked?
    marked
  end

private

  def users_correct_if_real?
    user_is_correct_if_real?(:pupil, self.pupil_id, 1)
    user_is_correct_if_real?(:marker, self.marker_id, 3)
  end
end
