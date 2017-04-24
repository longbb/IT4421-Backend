class Variant < ApplicationRecord
  belongs_to :product, optional: true

  validates :original_price, presence: true, numericality: { greater_than: 0 }
  validates :selling_price, presence: true, numericality: { greater_than: 0 }
  validates :image_url, presence: true
  validates :inventory, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: Settings.variant.status
end
