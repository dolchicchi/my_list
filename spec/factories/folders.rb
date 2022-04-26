FactoryBot.define do
  factory :folder do
    title { Faker::Name.initials(number: 2) }
    association :user
  end
end
