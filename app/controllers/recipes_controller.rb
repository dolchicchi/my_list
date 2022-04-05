class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :destroy, :folder_out, :user_check]
  before_action :user_check, only: :edit
  before_action :user_folder_set, only: [:new, :edit]
  before_action :no_select_check, only: :folder_in

  def new
    @recipe_ingredient = RecipeIngredient.new
  end

  # フォームオブジェクトパターン recipeとingredientテーブルに分けて保存
  def create
    recipe_ingredient = RecipeIngredient.new(recipe_ingredient_params)
    if recipe_ingredient.valid?
      recipe_ingredient.save
      redirect_to new_recipe_path
    else
      user_folder_set
      render :new
    end
  end

  def index
    @recipes = current_user.recipes.includes(:lists, :ingredients)
    @user_recipes = search_hit_recipe(@recipes)
    @last_dates = last_dates
  end

  def edit
  end

  def update 
    if @recipe.update(recipe_params)
      redirect_to recipes_path
    else
      user_folder_set
      render :edit 
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path
  end

  def folder_in
    recipe_ids = params.require(:folder).permit(recipe_ids: [])[:recipe_ids]

    recipe_ids.each do |recipe_id|
      recipe = Recipe.find(recipe_id)
      unless recipe.update(folder_id: params[:id])
        render :add_recipe_select
        return
      end
    end
    redirect_to folder_path(params[:id])
  end

  def folder_out
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

  def user_check
    unless current_user.id == @recipe.user_id
      redirect_to root_path
    end
  end

  def user_folder_set
    @folders = current_user.folders
  end

  # 追加レシピが選択されていない場合はリダイレクトする
  def no_select_check
    if params[:folder].blank?
      redirect_to add_recipe_select_folder_path(params[:id])
    end
  end

  # 検索結果を返す(引数に絞り込みの対象を渡す)Gem:Ransack使用
  def search_hit_recipe(recipes)
    @q = recipes.ransack(params[:q])
    @q.result(distinct: true)
  end

  def last_dates
    @last_dates = {}
    @recipes.each do |recipe|
      last_data = recipe.lists.select{|list| list.date < @today - 1}[0]
      unless last_data.blank?
        @last_dates[recipe.id] = last_data.date
      else
        @last_dates[recipe.id] = "履歴無し"
      end
    end
    return @last_dates
  end
end