class ListsController < ApplicationController
  before_action :set_lists, only: [:new, :index]

  def index
  end

  def new
  end

  def select
    @list = List.new
    @recipe_lists = current_user.recipes
    @date = params[:date]
  end

  def create
    list = List.new(list_params)
    if list.save
      redirect_to new_list_path
    end
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to new_list_path
  end

  def random
    recipe = random_recipe
    list_date = {recipe_id: recipe.id, user_id: current_user.id, date: params[:date]}
    random_save(list_date)
  end

  private
  def list_params
    params.require(:list).permit(:recipe_id).merge(user_id: current_user.id, date: params[:date])
  end

  def set_lists
    @today = Date.today
    @lists = current_user.lists.where(date: @today..@today + 7)
  end

  def random_recipe
    recipes = current_user.recipes
    number = rand(recipes.length - 1)
    recipe = recipes[number]
  end

  def random_save(list_date)
    list = List.new(list_date)
    if list.save
      redirect_to new_list_path
    else
      render :new
    end
  end
end
