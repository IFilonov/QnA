FactoryBot.define do
  sequence :title do |n|
    "MyString #{n}"
  end

  sequence :body do |n|
    "MyBody #{n}"
  end

  factory :question do
    title
    body
  end

  trait :invalid do
    title { nil }
  end
end
