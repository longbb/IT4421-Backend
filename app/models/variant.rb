class Variant < ApplicationRecord
  belongs_to :product, optional: true

  validate :original_price, presence: true, numericality: { greater_than: 0 }
  validate :selling_price, presence: true, numericality: { greater_than: 0 }
  validate :image_url, presence: true
  validate :inventory, presence: true, numericality: { greater_than: 0 }
  validate :status, presence: true, inclusion: Settings.variant.status
end
