FactoryBot.define do
  factory :recipe_ingredient do
    title          { Faker::Name.name }
    source         { Faker::Internet.url }
    name           { Faker::Name.name }
    amount         { Faker::Number.between(from: 1, to: 999) }
    unit_id        { Faker::Number.between(from: 2, to: 7) }
    category_id    { Faker::Number.between(from: 1, to: 4) }
    genre_id       { Faker::Number.between(from: 1, to: 4) }
    type_id        { Faker::Number.between(from: 1, to: 4) }
  end
end
