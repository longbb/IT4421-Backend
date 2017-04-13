class Variant < ApplicationRecord
  belongs_to :product, optional: true

  validate :original_price, presence: true
end
