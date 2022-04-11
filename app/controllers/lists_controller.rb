class ListsController < ApplicationController
  before_action :set_user_lists, only: [:new, :index, :weekly_destroy]
  before_action :set_user_recipes, only: [:new, :index]
  before_action :last_dates,  only: [:new, :index]
  before_action :new_list, only: [:new, :index]

  def new
    @date = params[:date]
    @user_recipes = search_hit_recipe(@recipes)
  end

  def index
    @wdays = ["(日)", "(月)", "(火)", "(水)", "(木)", "(金)", "(土)"]
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
    else
      flash[:danger] = "レシピ登録を一件以上して下さい"
      redirect_to root_path
      return
    end
    redirect_to root_path
  end

  def weekly_destroy
    if @lists.order(created_at: :desc).limit(7).destroy_all
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
    @lists = List.weekly_lists(current_user.id)
  end

  def set_user_recipes
    @recipes = current_user.recipes.includes(:lists)
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
        date: @today
      }
    end
  end
  
  # ユーザーのレシピごとに献立に登録された最終日付を取得
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
