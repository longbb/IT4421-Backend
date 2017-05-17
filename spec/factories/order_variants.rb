FactoryGirl.define do
  factory :order_variant do
    order_id 1
    variant_id 1
    quantity 1
    unit_price 1
    status "MyString"
  end
end
