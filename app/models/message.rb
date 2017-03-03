class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, class_name: 'User'
  has_many :unread_messages, dependent: :destroy

  after_create :push_unread_message

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
      errors.add(:sender, 'must be member of chat group')
    end
  end

  def push_unread_message
    group = chat.users.where.not(id: sender.id)
    group.each do |user|
      self.unread_messages.create(recipient: user)
    end
  end
end
