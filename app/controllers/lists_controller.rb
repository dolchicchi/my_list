class ListsController < ApplicationController
  before_action :set_lists, only: [:new, :index, :all_destroy]
  before_action :check_recipe, only: [:random, :all_random]
  before_action :set_search, only: :new

  def index
  end

  def new
    @list = List.new
    @recipe_lists = current_user.recipes
    @date = params[:date]
  end

  def create
    list = List.new(list_params)
    if list.save
      redirect_to lists_path
    end
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to lists_path
  end

  def random
    recipe = random_recipe
    list_date = {recipe_id: recipe.id, user_id: current_user.id, date: params[:date]}
    random_save(list_date)
    redirect_to lists_path
  end

  def all_random
    today = Date.today
    7.times do |i|
    recipe = random_recipe
    list_date = {recipe_id: recipe.id, user_id: current_user.id, date: (today + i)}
    random_save(list_date)
    end
    redirect_to lists_path
  end

  def all_destroy
    if @lists.destroy_all
      redirect_to lists_path
    else
      render :new
    end
  end

  private
  def list_params
    params.require(:list).permit(:recipe_id).merge(user_id: current_user.id, date: params[:date])
  end

  def set_lists
    @wdays = ["(日)", "(月)", "(火)", "(水)", "(木)", "(金)", "(土)"]
    @today = Date.today
    if user_signed_in?
      @lists = current_user.lists.where(date: @today..@today + 7).order(date: :asc)
    else
      @lists = []
    end
  end

  def set_wday
    wdays = ["(日)", "(月)", "(火)", "(水)", "(木)", "(金)", "(土)"]
  end
    

  def random_recipe
    recipes = current_user.recipes
    number = rand(recipes.length) - 1
    recipe = recipes[number]
  end

  def random_save(list_date)
    list = List.new(list_date)
    unless list.save
      render :index
    end
  end

  def check_recipe
    if current_user.recipes.empty?
      redirect_to root_path
    end
  end
  
  def set_search
    @recipes = current_user.recipes.order(updated_at: :desc)
    @q = @recipes.ransack(params[:q])
    @search_recipes = @q.result(distinct: true)
  end
end
