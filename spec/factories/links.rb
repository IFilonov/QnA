FactoryBot.define do
  factory :link do
    name { "MyLink" }
    url { "http://MyUrl.ru" }
  end

  trait :gist_link do
    name { "Gist" }
    url { "https://gist.github.com/IFilonov/7d817a0aa1f1d0a8755135aacf01f72c" }
  end
end
