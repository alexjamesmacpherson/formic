class Notification < ApplicationRecord
  belongs_to :user

  # Remove whitespace
  auto_strip_attributes :title, :message, :link, :squish => true

  validates :user,
            presence: true
  validates :title, :message,
            presence: true,
            length: { maximum: 255 }
  validates :link,
            presence: true,
            length: { maximum: 255 },
            allow_blank: true
  validate :user_exists?
end
