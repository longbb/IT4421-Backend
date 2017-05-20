class Product < ApplicationRecord
  before_save :create_slug

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

  def create_slug
    self.slug = self.title.parameterize
  end

  def min_price
    self.variants.minimum(:selling_price)
  end

  def max_price
    self.variants.maximum(:selling_price)
  end

  def total_inventory
    self.variants.sum(:inventory)
  end

  class << self
    def search page_no=nil, per_page=nil, key_word=nil
      result = Product.all
      if per_page.present? && page_no.present?
        result = result.limit(per_page).offset((page_no - 1) * per_page)
      end
      if key_word.present?
        key_word_slug = key_word.parameterize
        result = result.where("slug LIKE ?", "%#{ key_word_slug }%")
      end
      result
    end
  end
end
