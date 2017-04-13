FactoryGirl.define do
  factory :admin_session do
    admin_id 1
    token_key "MyString"
    status "active"
  end
end
