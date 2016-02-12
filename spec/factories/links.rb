FactoryGirl.define do
  factory :link do
    url { Faker::Internet.url }
    title { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph }
    read { [false, true].sample }
    user
  end
end
