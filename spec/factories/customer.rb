FactoryGirl.define do
  factory :customer do
    email "user@test.com"
    fullname "customer_name"
    phone_number "0147963258"
    address "Customer address"
    status "Active"
  end
end
