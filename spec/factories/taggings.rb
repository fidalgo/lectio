FactoryGirl.define do
  factory :tagging do
    tag
    association :taggable, factory: :link
    association :tagger, factory: :user
  end
end
