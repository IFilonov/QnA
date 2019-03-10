FactoryBot.define do
  sequence :answer_body do |n|
    "AnswerBody #{n}"
  end

  factory :answer do
    body { generate :answer_body }
  end

  trait :invalid_answer do
    body { nil }
  end
end
