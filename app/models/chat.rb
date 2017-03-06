class Chat < ApplicationRecord
  has_many :users, through: :converses, source: :user
  has_many :converses, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :unread_messages, through: :messages

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  validates :name,
            presence: true,
            length: { maximum: 255 },
            allow_blank: true
  validates :converses,
            length: { minimum: 2 }

  def read_all_for(user)
    unread = unread_messages.where(recipient_id: user.id)
    unread.each do |m|
      m.destroy!
    end if unread
  end

  def unread_count_for(user)
    unread_messages.where(recipient_id: user.id).count
  end

  def read_by?(user)
    unread_count_for(user) == 0
  end
end
