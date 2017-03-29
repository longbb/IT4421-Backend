FactoryGirl.define do
  factory :user do
    email "user@test.com"
    password "password"
    status "Active"
  end
end
