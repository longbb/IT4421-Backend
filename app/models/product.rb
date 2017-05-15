class Product < ApplicationRecord
  belongs_to :supplier
  has_many :variants

  accepts_nested_attributes_for :variants

  validates :title, presence: true
  validates :description, presence: :true
  validates :status, presence: true, inclusion: Settings.product.status
  scope :active, -> { where(status: "active") }

  def is_active?
    self.status == "active"
  end

  class << self
    def search page_no=nil, per_page=nil, key_word=nil
      result = Product.all
      if per_page.present? && page_no.present?
        result = result.limit(per_page).offset((page_no - 1) * per_page)
      end
      if key_word.present?
        result = result.where("title LIKE ?", "%#{ key_word }%")
      end
      result
    end
  end
end
