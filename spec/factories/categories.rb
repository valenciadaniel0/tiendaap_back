FactoryBot.define do
  factory :category do
    name { '1 pound' }
    picture { 'testpicture.png' }
    stock { 10 }
    price { 2000 }
  end

  trait :with_product do
    product { create :product, :with_user }
  end
end
