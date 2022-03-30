class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :destroy, :folder_delete]
  before_action :set_search, only: :index
  before_action :user_match?, only: [:edit, :update, :destroy]
  before_action :user_folder_set, only: [:new, :edit]
  def new
    @recipe_ingredient = RecipeIngredient.new
  end

  def create
    @recipe_ingredient = RecipeIngredient.new(recipe_ingredient_params)
    if @recipe_ingredient.valid?
      @recipe_ingredient.save
      redirect_to recipes_path
    else
      render :new
    end
  end

  def index

  end

  def edit
  end

  def update 
    if @recipe.update(recipe_params)
      redirect_to recipes_path
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path
  end

  def folder_delete
    if @recipe.update(folder_id: :nil)
      redirect_to folder_path(params[:folder_id])
    else
      render root_path
    end
  end

  private
  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(
      :title, :source, :folder_id,
      :category_id, :genre_id, :type_id,
      name: [], amount: [], unit_id: []
    ).merge(user_id: current_user.id)
  end

  def recipe_params
    params.require(:recipe).permit(
      :title, :source, :folder_id,
      :category_id, :genre_id, :type_id
    )
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end


  def set_search
    @recipes = current_user.recipes.order(updated_at: :desc)
    @q = @recipes.ransack(params[:q])
    @search_recipes = @q.result(distinct: true)
  end

  def user_match?
    recipe = Recipe.find(params[:id])
    unless current_user.id == recipe.user_id
      redirect_to root_path
    end
  end

  def user_folder_set
    @folders = current_user.folders
  end

end
