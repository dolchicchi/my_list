class RecipesController < ApplicationController

  def new
    @recipe_ingredient = RecipeIngredient.new
  end

  def create
    @recipe_ingredient = RecipeIngredient.new(recipe_params)
    if @recipe_ingredient.valid?
      @recipe_ingredient.save
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def recipe_params
    params.require(:recipe_ingredient).permit(
      :title, :source,
      :name, :amount, :unit_id
    ).merge(user_id: current_user.id)
  end
end
