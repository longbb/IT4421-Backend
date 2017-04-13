FactoryGirl.define do
  factory :admin do
    email "admin@test.com"
    password "password"
    password_confirmation "password"
    status "active"
  end
end
