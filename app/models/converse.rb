class Converse < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  # Record validation
  validates :chat,
            presence: true,
            uniqueness: { scope: :user }
  validates :user,
            presence: true
  # Validate user and chat actually exist
  validate :user_exists?
  validate :chat_exists?
end
