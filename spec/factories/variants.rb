FactoryGirl.define do
  factory :variant do
    product_id 1
    original_price 1
    selling_price 1
    properties "MyString"
    image_url "MyString"
    inventory 1
    status "active"
  end
end
