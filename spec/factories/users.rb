FactoryBot.define do
  sequence :email do |n|
    "test#{n}@mail.com"
  end

  factory :user do
    email
    password { '123456789' }
  end
end
