class Notification < ApplicationRecord
  belongs_to :user

  before_create :delete_old_notifications

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

private

  def delete_old_notifications
    if Notification.where(user_id: user_id).order(:created_at).count >= 20
      Notification.where(user_id: user_id).order(:created_at).first.destroy
    end
  end
end
