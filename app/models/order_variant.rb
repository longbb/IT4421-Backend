class OrderVariant < ApplicationRecord
  belongs_to :order
  belongs_to :variant
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: Settings.order.status }
end
