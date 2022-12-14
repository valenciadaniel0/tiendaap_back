FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    name { Faker::Internet.username }
    password { Faker::Internet.password }
    role { 2 }
  end
end
