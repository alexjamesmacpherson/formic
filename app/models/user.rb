class User < ApplicationRecord
  belongs_to :school
  has_many :tutors, :class_name => 'Tutor', :foreign_key => 'tutor_id', dependent: :destroy
  has_many :pupils, :class_name => 'Tutor', :foreign_key => 'pupil_id', dependent: :destroy
  has_many :parents, :class_name => 'Parent', :foreign_key => 'parent_id', dependent: :destroy
  has_many :children, :class_name => 'Parent', :foreign_key => 'child_id', dependent: :destroy

  # Remove whitespace
  auto_strip_attributes :email, :name, :address, :bio, :squish => true

  # Downcase email address before saving the user
  before_save :downcase_email

  # Record validation
  validates :school,
            presence: true
  # Regular expression matches email of valid form
  VALID_EMAIL_REGEX = /\A([\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+)?\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :user_group,
            presence: true,
            inclusion: 0..5
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :address,
            presence: true,
            allow_blank: true
  validates :bio,
            presence: true,
            allow_blank: true
  has_secure_password
  validates :password,
            presence: true,
            length: { minimum: 6 }

  # Returns hashed digest of given string, used by user fixtures for tests
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

private

  def downcase_email
    email.downcase!
  end
end
