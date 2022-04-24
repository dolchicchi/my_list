FactoryBot.define do
  factory :recipe do
    title          { Faker::Name.initials(number: 2) }
    source         { Faker::Internet.url }
    category_id    { Faker::Number.between(from: 1, to: 5) }
    genre_id       { Faker::Number.between(from: 1, to: 6) }
    type_id        { Faker::Number.between(from: 1, to: 4) }
  end
end
