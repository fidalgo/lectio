FactoryGirl.define do
  factory :user do
    name "Test user"
    email "test@example.com"
    password "Us3rP@assw0rD"
    password_confirmation "Us3rP@assw0rD"
  end

end
