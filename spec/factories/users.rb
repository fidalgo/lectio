FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email  { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    role { User.roles['user'] }
    factory :admin do
      role { User.roles['admin'] }
    end
  end
end
