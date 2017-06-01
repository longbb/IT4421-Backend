class OrderVariant < ApplicationRecord
  belongs_to :order
  belongs_to :variant
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: Settings.order.status }

  class << self
    def top_3_product
      number_orders_array = self.group(:variant_id).count
      number_orders_hash = Hash.new
      number_orders_array.each do |key, value|
        variant = Variant.find(key.to_i)
        product_id = variant.product_id
        if number_orders_hash[product_id].present?
          number_orders_array[product_id] += value
        else
          number_orders_hash[product_id] = value
        end
      end
      orders_array = number_orders_hash.sort_by{ |id, number_orders| number_orders }.reverse
      if orders_array.length > 3
        orders_array = orders_array[0..2]
      end
      product_array = Array.new
      orders_array.each do |order|
        product_array.push(Product.find(order[0]))
      end
      return product_array
    end
  end
end
