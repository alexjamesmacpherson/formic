class UnreadMessage < ApplicationRecord
  belongs_to :message
  belongs_to :recipient, class_name: 'User'

  validates :message, :recipient,
            presence: true
  validate :recipient_exists?
  validate :message_exists?
  validate :sent_to_chat_member?

private

  def recipient_exists?
    is_record?(:recipient, User, recipient_id)
  end

  def message_exists?
    is_record?(:message, Message, message_id)
  end

  def sent_to_chat_member?
    unless message && message.chat.users.include?(recipient)
      errors.add(:recipient, 'must be member of chat group')
    end
  end
end
