FactoryBot.define do
  factory :item do
    code { Faker::Code.npi }
    status { 1 }
  end
end
