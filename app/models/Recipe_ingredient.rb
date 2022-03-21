class RecipeIngredient
  include ActiveModel::Model
  attr_accessor :title, :source, :user_id, :name, :amount, :unit_id, :recipe

  with_options presence: true do
    validates :title
    validates :user_id
  end

  def save
    recipe  = Recipe.create(
      title: title,
      source: source,
      user_id: user_id
    )

    ingredients = [name, amount, unit_id].transpose
    
    ingredients.each do |ingredient|
      header = ["name", "amount", "unit_id"]
      ingredient_parameter = Hash[header.zip(ingredient)]
      ingredient_parameter["recipe_id"] = recipe.id
      Ingredient.create(ingredient_parameter)
    end



  end
end
