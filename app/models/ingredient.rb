class Ingredient < ApplicationRecord
  belongs_to :recipe
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :unit

  with_options presence: true do
   validates :name
   validates :amount, numericality: { with: /[0-9０-９,，.．]+/ }
  end
  validates :unit_id, numericality: { other_than: 1 }

  def self.weekly_ingredients_date(weekly_recipes)
    weekly_ingredient = []
    weekly_recipes.each do |day_recipe|
      weekly_ingredient << day_recipe.ingredients
    end
    return weekly_ingredient.flatten!
  end
end
 