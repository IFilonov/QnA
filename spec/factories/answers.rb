FactoryBot.define do
  factory :answer do
    body
  end

  trait :invalid_answer do
    body { nil }
  end
end
