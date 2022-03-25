FactoryBot.define do
  factory :recipe do
    title          { Faker::Name.name }
    source         { Faker::Internet.url }
  end
end
