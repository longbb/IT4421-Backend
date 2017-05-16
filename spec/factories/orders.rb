FactoryGirl.define do
  factory :order do
    customer_id 1
    total_price 1
    status "MyString"
  end
end
