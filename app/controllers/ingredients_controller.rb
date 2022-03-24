class IngredientsController < ApplicationController
  before_action :new_ingredient, only: [:new, :create]
  before_action :ingredient_set, only: [:edit, :update, :destroy]
  before_action :recipe_set, only: [:new, :create,:edit, :update]
  before_action :user_match?, only: [:edit, :update, :destroy]
  
  def new
  end

  def create
    ingredients.each do |ingredient|
      header = ["name", "amount", "unit_id"]
      ingredient_parameter = Hash[header.zip(ingredient)]
      ingredient_parameter["recipe_id"] = params[:recipe_id]
      ingredient = Ingredient.new(ingredient_parameter)
      unless ingredient.save
        render :new
        return
      end
    end
    redirect_to recipes_path
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to recipes_path
    else
      render :edit
    end
  end

  def destroy
    @ingredient.destroy
    redirect_to recipes_path
  end

  private
  def new_ingredient
   @ingredient = Ingredient.new
  end

  def ingredient_set
    @ingredient = Ingredient.find(params[:id])
  end

  def recipe_set
    @recipe = Recipe.find(params[:recipe_id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :amount, :unit_id)
  end

  def ingredients
    ingredients_params = params[:recipe_ingredient]
    names = ingredients_params[:name]
    amounts = ingredients_params[:amount]
    amounts.each do |amount|
      amount.tr!("０-９", "0-9")
    end
    unit_ids = ingredients_params[:unit_id]
    ingredients = [names, amounts, unit_ids].transpose
  end

  def user_match?
    recipe = Recipe.find(params[:recipe_id])
    unless current_user.id == recipe.user_id
      redirect_to root_path
    end
  end

end
