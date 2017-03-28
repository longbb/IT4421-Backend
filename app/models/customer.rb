class Customer < ApplicationRecord
  has_one :user
  before_save { self.email = email.downcase }
  before_save { self.fullname = fullname.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :fullname, presence: true, length: { maximum: 50 }
  VALID_PHONE_NUMBER_REGEX = /\A[0-9]+\z/
  validates :phone_number, presence: true,
    format: { with: VALID_PHONE_NUMBER_REGEX }, length: { in: 10..11 }
  validates :address, presence: true
  validates :status, presence: true, inclusion: { in: Settings.user.status }
end
