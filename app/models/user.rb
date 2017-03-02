class User < ApplicationRecord
  belongs_to :school
  belongs_to :year_group

  has_many :tutors, :class_name => 'Tutor', :foreign_key => 'tutor_id', dependent: :destroy
  has_many :pupils, :class_name => 'Tutor', :foreign_key => 'pupil_id', dependent: :destroy

  has_many :parents, :class_name => 'Parent', :foreign_key => 'parent_id', dependent: :destroy
  has_many :children, :class_name => 'Parent', :foreign_key => 'child_id', dependent: :destroy

  has_many :departments, :foreign_key => 'head_id', dependent: :nullify

  has_many :grades, :class_name => 'Study', :foreign_key => 'pupil_id', dependent: :destroy
  has_many :subjects, through: :studies

  has_many :teaches, :foreign_key => 'teacher_id', dependent: :destroy
  has_many :subjects, through: :teaches

  has_many :submissions, :foreign_key => 'pupil_id', dependent: :destroy
  has_many :submitted, :class_name => 'Submission', :foreign_key => 'marker_id', dependent: :destroy

  # Attribute accessors
  attr_accessor :remember_token, :activation_token, :reset_token

  # Remove whitespace
  auto_strip_attributes :email, :name, :squish => true
  auto_strip_attributes :bio, :convert_non_breaking_spaces => true

  # Record cleansing before saving/creation
  before_save :downcase_email
  before_save :titlize_name
  before_create :create_activation_digest

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
  # User group: 0: SU, 1: student, 2: parent, 3: teacher, 4: admin staff, 5: governor
  validates :group,
            presence: true,
            inclusion: 0..5
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :bio,
            presence: true,
            allow_blank: true
  has_secure_password
  validates :password,
            presence: true,
            length: { minimum: 6 },
            allow_nil: true
  validates :year_group,
            presence: true,
            if: :is_student?
  # Validate user cannot be added to a non-existent school or year group
  validate :school_exists
  validate :year_group_exists

  # Methods defined here are of form User.foo()
  class << self
    # Returns hashed digest of given string, used by user fixtures for tests
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Generate and return a new random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Generate and set persistent session (remember) token
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forget persistent session (remember) token
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Checks remember digest against given remember token (from cookie), true if match, false otherwise (catches nil token case)
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Generic equality method for any user attribute
  def is?(attribute, value)
    send(attribute) == value
  end

private

  # Downcase email address before saving the user
  def downcase_email
    email.downcase!
  end

  # Titlize name before saving the user
  def titlize_name
    self.name = name.titleize
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def school_exists
    unless School.exists?(school_id)
      errors.add(:school, 'must exist')
    end
  end

  def year_group_exists
    if is_student? && !YearGroup.exists?(year_group_id)
      errors.add(:year_group, 'must exist')
    end
  end

  def is_student?
    is?(:group, 1)
  end
end
