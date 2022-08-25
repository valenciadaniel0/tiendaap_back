FactoryBot.define do
  factory :product do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    inventory { true }

    trait :with_user do
      user { create :user }
    end
  end
end
