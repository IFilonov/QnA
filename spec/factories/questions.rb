FactoryBot.define do
  sequence :title do |n|
    "MyString #{n}"
  end

  sequence :body do |n|
    "MyBody #{n}"
  end

  factory :question do
    title { generate :title }
    body { generate :body }
  end

  trait :invalid do
    title { nil }
  end
end
