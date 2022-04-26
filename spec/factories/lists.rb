FactoryBot.define do
  factory :list do
    date { Faker::Date.between(from: Date.today + 1, to: Date.today + 3) }
    association :user
    association :recipe
  end
end
