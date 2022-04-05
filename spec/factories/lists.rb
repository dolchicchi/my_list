FactoryBot.define do
  factory :list do
    date              { Faker::Date.between(from: '1930-01-1', to: Date.today) }
    association :user
    association :recipe
  end
end
