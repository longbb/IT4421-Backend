FactoryGirl.define do
  factory :feedback do
    email "test@mail.com"
    feedback "MyString"
    status "active"
  end
end
