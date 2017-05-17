class Variant < ApplicationRecord
  belongs_to :product, optional: true
  has_many :order_variants

  validates :original_price, presence: true, numericality: { greater_than: 0 }
  validates :selling_price, presence: true, numericality: { greater_than: 0 }
  validates :image_url, presence: true
  validates :inventory, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: Settings.variant.status
  scope :active, -> { where(status: "active") }
end
