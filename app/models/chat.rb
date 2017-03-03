class Chat < ApplicationRecord
  has_many :users, through: :converses, source: :user
  has_many :converses, dependent: :destroy

  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :converses,
            length: { minimum: 2 }
end
