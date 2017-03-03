class Chat < ApplicationRecord
  has_many :users, through: :converses, source: :user
  has_many :converses, dependent: :destroy
  has_many :messages, dependent: :destroy

  # Remove whitespace
  auto_strip_attributes :name, :squish => true

  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :converses,
            length: { minimum: 2 }
end
