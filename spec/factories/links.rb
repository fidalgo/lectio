FactoryGirl.define do
  factory :link do
    sequence(:url,200000){ |n| "https://bugs.kde.org/show_bug.cgi?id={n}" }
  end

end
