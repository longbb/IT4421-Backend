FactoryGirl.define do
  factory :admin do
    email "admin@test.com"
    password "admin123"
    password_confirmation "admin123"
    status "active"
  end
end
