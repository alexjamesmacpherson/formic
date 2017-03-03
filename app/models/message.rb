class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, class_name: 'User'

  # Remove whitespace
  auto_strip_attributes :text, :convert_non_breaking_spaces => true

  validates :chat, :sender, :text,
            presence: true
  validate :chat_exists?
  validate :sender_exists?
  validate :sent_by_chat_member

  def sent_at
    created_at
  end

private

  def sender_exists?
    is_record?(:sender, User, sender_id)
  end

  def sent_by_chat_member
    unless chat && chat.users.include?(sender)
      errors.add(:user, 'must be member of chat group')
    end
  end
end
