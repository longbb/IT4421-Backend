FactoryGirl.define do
  factory :user do
    email "user@test.com"
    fullname "user_test"
    password "password"
    address "Ha Noi"
    phone_number "1234567890"
    status "Active"
  end
end
