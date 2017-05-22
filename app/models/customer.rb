class Customer < ApplicationRecord
  has_one :user
  before_save { self.email = email.downcase }
  before_save { self.fullname = fullname.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }
  validates :fullname, presence: true, length: { maximum: 50 }
  VALID_PHONE_NUMBER_REGEX = /\A[0-9]+\z/
  validates :phone_number, presence: true,
    format: { with: VALID_PHONE_NUMBER_REGEX }, length: { in: 10..11 }
  validates :address, presence: true
  validates :status, presence: true, inclusion: { in: Settings.user.status }

  def is_active?
    self.status == "Active"
  end

  class << self
    def search page_no=nil, per_page=nil, name=nil
      result = Customer.all
      if per_page.present? && page_no.present?
        result = result.limit(per_page).offset((page_no - 1) * per_page)
      end

      if name.present?
        result = result.where("fullname LIKE ?", "%#{ name }%")
      end
      result
    end
  end
end
