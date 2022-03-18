class RecipesController < ApplicationController

  def new
    @recipe_ingredient = RecipeIngredient.new
  end

  def create
    # @recipe = Recipe.new(recipe_params)
    # if @recipe.save
    #   redirect_to root_path
    # else
    #   render :new
    # end

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
      :string, :amount, :unit_id
    ).merge(user_id: current_user.id)
  end

  # def recipe_params
  #   params.require(:recipe).permit(:title, :source).merge(user_id: current_user.id)
  # end
end
