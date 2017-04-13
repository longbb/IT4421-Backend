class Product < ApplicationRecord
  belongs_to :supplier

  validates :title, presence: true
  validates :description, presence: :true
  validates :status, presence: true, inclusion: Settings.product.status
end
