class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_variants
  has_many :variants, through: :order_variants
  validates :status, presence: true, inclusion: { in: Settings.order.status }
  validates :total_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  scope :filter_by_customer, -> (customer) { where(customer_id: customer, status: "active") }
  scope :active, -> { where(status: "active") }

  class << self
    def search customer, page_no=nil, per_page=nil, daterange=nil
      result = Order.filter_by_customer(customer)
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
  end
end
