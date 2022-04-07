FactoryBot.define do
  factory :list do
    date              { Faker::Date.between(from: Date.today, to: Date.today + 7) }
    association :user
    association :recipe
  end
end
