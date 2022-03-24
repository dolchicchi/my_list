class RecipeIngredient
  include ActiveModel::Model
  attr_accessor :title, :source, :user_id, :name, :amount, :unit_id, :recipe

  with_options presence: true do
    validates :title
    validates :user_id
  end



  def save
    recipe  = Recipe.create(title: title, source: source, user_id: user_id)
    
    ingredients_transpose.each do |ingredient|
      header = ["name", "amount", "unit_id"]
      ingredient_parameter = Hash[header.zip(ingredient)]
      ingredient_parameter["recipe_id"] = recipe.id
      Ingredient.create(ingredient_parameter)
    end
  end

  def ingredients_transpose
    am =[]
    amount.each do |a|
      am << a.tr('０-９','0-9')
    end
    ingredients_transpose = [name, am, unit_id].transpose
  end

end
