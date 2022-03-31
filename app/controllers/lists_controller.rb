class ListsController < ApplicationController
  before_action :set_lists, only: [:new, :index, :all_destroy]
  before_action :check_recipe, only: :random
  before_action :set_search, only: [:new, :index]

  def index
    @list = List.new
  end

  def new
    @list = List.new
    @recipe_lists = current_user.recipes
    @date = params[:date]
  end

  def create
    if params[:list].present?
      List.create(list_params)
      redirect_to lists_path
    else
      redirect_to new_list_path
    end
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to lists_path
  end

  def random
    if params[:list][:date].present? && random_params.present?
      List.create(random_params)
    elsif random_params.present?
      7.times do |i|
        list = List.new(random_params)
        list.date += i
        list.save
      end
    end
    redirect_to root_path
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
    @lists = current_user.lists.where(date: @today..@today + 7).order(date: :asc)
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

  def select_category_params
    params.require(:recipe).permit(
      :category_id, :genre_id, :type_id
    ).merge(user_id: current_user.id)
  end

  def random_params
    recipe = Recipe.random(select_category_params)
    
    if recipe.present? && params[:list][:date].present?
      return {recipe_id: recipe.id, user_id: current_user.id, date: params[:list][:date]}
    elsif recipe.present? && params[:list][:date].blank?
      return {recipe_id: recipe.id, user_id: current_user.id, date: Date.today}
    end

  end
  
end
