class User < ApplicationRecord
  before_save :generate_password_digest
  after_save :clear_password
  before_save { self.email = email.downcase }
  before_save { self.fullname = fullname.downcase }

  attr_accessor :password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  VALID_NAME_REGEX = /\A\b[^-_][\w]*[^-_]\b\z/
  validates :fullname, presence: true, length: { maximum: 50 }, format: { with: VALID_NAME_REGEX }
  VALID_PHONE_NUMBER_REGEX = /\A[0-9]+\z/
  validates :phone_number, presence: true,
    format: { with: VALID_PHONE_NUMBER_REGEX }, length: { in: 10..11 }
  validates :password, confirmation: true
  validates_length_of :password, in: 8..20, on: :create
  validates_length_of :password, in: 8..20, allow_nil: true, on: :update
  validates :address, presence: true
  validates :status, presence: true, inclusion: { in: Settings.user.status }

  def generate_password_digest
    if password.present?
      self.password_digest = BCrypt::Password.create(self.password, cost: 10)
    end
  end

  def clear_password
    self.password = nil
    self.password_confirmation = nil
  end

  def authenticate password
    bcrypt = BCrypt::Password.new self.password_digest
    BCrypt::Engine.hash_secret(password, bcrypt.salt) == self.password_digest
  end
end
