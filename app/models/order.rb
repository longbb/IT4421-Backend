class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_variants
  has_many :variants, through: :order_variants
  validates :status, presence: true, inclusion: { in: Settings.order.status }
  validates :total_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  scope :filter_by_customer, -> (customer) { where(customer_id: customer) }
  scope :active, -> { where(status: "active") }

  class << self
    def search customer=nil, page_no=nil, per_page=nil, daterange=nil
      if customer.present?
        result = Order.filter_by_customer(customer)
      else
        result = Order.all
      end
      if per_page.present? && page_no.present?
        result = result.limit(per_page).offset((page_no - 1) * per_page)
      end
      if daterange.present?
        start_date = daterange.split("-")[0]
        end_date = daterange.split("-")[1]
        start_date = Date.strptime(start_date, "%m/%d/%Y").beginning_of_day
        end_date = Date.strptime(end_date, "%m/%d/%Y").beginning_of_day
        result = result.where("created_at BETWEEN ? AND ?", "%#{ start_date }%", "%#{ end_date}%")
      end
      result
    end

    def check_valid_order variants
      result = {
        'valid': true
      }
      variants.each do |variant_info|
        variant = Variant.find_by(id: variant_info[:variant_id], status: "active")
        if variant.present?
          unless variant.inventory >= variant_info[:quantity]
            result = {
              'valid': false,
              'message': 'Not enough quantity',
              'error_code': 401
            }
          end
        else
          result = {
            'valid': false,
            'message': 'Variant not found',
            'error_code': 404
          }
          break
        end
      end
      return result
    end

    def statistic_revenues start_date, end_date
      statistic_revenues = {
        data: Array.new,
        date: Array.new
      }
      (start_date..end_date).each do |date|
        revenues = self.where(created_at: date.beginning_of_day..date.end_of_day).sum(:total_price)
        statistic_revenues[:data].push revenues
        statistic_revenues[:date].push date.to_s
      end
      statistic_revenues
    end
  end
end
