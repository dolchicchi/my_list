class RecipeIngredient
  include ActiveModel::Model
  attr_accessor :title, :source, :user_id, :string, :amount, :unit_id, :recipe

  with_options presence: true do
    validates :title, :user_id
  end

  def save
    recipe  = Recipe.create(
      title: title,
      source: source,
      user_id: user_id
    )

    Ingredient.create(
      string: string,
      amount: amount,
      unit_id: unit_id,
      recipe_id: recipe.id
    )
  end
end

