class ListsController < ApplicationController
  before_action :set_user_lists, only: [:new, :index, :weekly_destroy]
  before_action :new_list, only: [:new, :index]

  def new
    @date = params[:date]
    recipes = current_user.recipes.order(updated_at: :desc)
    @user_recipes = search_hit_recipe(recipes)
  end

  def index
  end

  def create
    if params[:list].present? && params[:date].present?
      List.create(list_params)
      redirect_to lists_path
    elsif params[:folder_id].present? || params[:date].blank?
      redirect_to folder_path(params[:folder_id])
    else
      redirect_to new_list_path(date: params[:date])
    end
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to lists_path
  end

  # 日付の指定がない場合は当日から7日分の献立を登録
  def random
    if params[:list][:date].present? && random_choice_recipe.present?
      List.create(random_choice_recipe)
    elsif random_choice_recipe.present?
      7.times do |i|
        list = List.new(random_choice_recipe)
        list.date += i
        list.save
      end
    end
    redirect_to root_path
  end

  def weekly_destroy
    if @lists.destroy_all
      redirect_to lists_path
    else
      render :new
    end
  end

  private
  def new_list
    @list = List.new
  end

  def list_params
    params.require(:list).permit(:recipe_id).merge(user_id: current_user.id, date: params[:date])
  end

  def set_user_lists
    @wdays = ["(日)", "(月)", "(火)", "(水)", "(木)", "(金)", "(土)"]
    @today = Date.today
    @lists = current_user.lists.where(date: @today..@today + 7).order(date: :asc)
  end

  # 検索結果を返す(引数に絞り込みの対象を渡す)Gem:Ransack使用
  def search_hit_recipe(recipes)
    @q = recipes.ransack(params[:q])
    @q.result(distinct: true)
  end

  # おまかせ機能を実行した時の絞り込み条件のパラメーター
  def select_category_params
    params.require(:recipe).permit(
      :category_id, :genre_id, :type_id
    ).merge(user_id: current_user.id)
  end

  # 引数に渡した条件に一致するレシピからランダムで取り出す
  # 日付の情報がない場合は当日の日付を入れる
  def random_choice_recipe
    recipe = Recipe.random(select_category_params)
    
    if recipe.present? && params[:list][:date].present?
      return {
        recipe_id: recipe.id, user_id: current_user.id,
        date: params[:list][:date]
      }
    elsif recipe.present? && params[:list][:date].blank?
      return {
        recipe_id: recipe.id, user_id: current_user.id,
        date: Date.today
      }
    end
  end
  
end
