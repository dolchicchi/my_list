FactoryBot.define do
  factory :ingredient do
    name           { Faker::Name.initials(number: 2) }
    amount         { Faker::Number.between(from: 1, to: 999) }
    unit_id        { Faker::Number.between(from: 2, to: 7) }
  end
end
