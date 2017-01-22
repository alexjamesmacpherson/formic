class User < ApplicationRecord
  belongs_to :school

  validates :school,
            presence: true
  VALID_EMAIL_REGEX = /\A([\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+)?\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }
  validates :user_group,
            presence: true,
            inclusion: 0..5
  validates :name,
            presence: true,
            length: { minimum: 5, maximum: 255 }
  validates :address,
            presence: true
  
end
