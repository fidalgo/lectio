FactoryGirl.define do
  factory :link do
    # sequence(:url) { |n| "https://bugs.kde.org/show_bug.cgi?id=#{n}" }
    url { Faker::Internet.url }
    read false
    association :user, factory: :user, strategy: :build
  end
end
