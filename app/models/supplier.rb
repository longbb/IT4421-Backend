class Supplier < ApplicationRecord
  has_many :products

  validates :name, presence: :true, length: { maximum: 50 }
  validates :address, presence: :true
  VALID_PHONE_NUMBER_REGEX = /\A[0-9]+\z/
  validates :phone_number, presence: :true,
    format: { with: VALID_PHONE_NUMBER_REGEX }, length: { in: 10..11 }
  validates :description, presence: :true
  validates :status, presence: :true, inclusion: { in: ["active", "deleted"] }

  scope :active, -> { where(status: "active") }

  def is_active?
    self.status == "active"
  end

  class << self
    def search page_no=nil, per_page=nil, key_word=nil
      result = Supplier.all
      if per_page.present? && page_no.present?
        result = result.limit(per_page).offset((page_no - 1) * per_page)
      end
      if key_word.present?
        result = result.where("name LIKE ?", "%#{ key_word }%")
      end
      result
    end
  end
end
