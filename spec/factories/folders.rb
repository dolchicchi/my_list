FactoryBot.define do
  factory :folder do
    title              { Faker::Name.name }
    association :user
  end
end
