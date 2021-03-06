class FoldersController < ApplicationController
  before_action :set_folder, except: %i[new create index]
  before_action :no_select_check, only: :add_recipe
  before_action :user_match?, only: %i[show edit add_recipe_select]

  def new
    @folder = Folder.new
  end

  def create
    folder = Folder.new(folder_params)
    if folder.save
      redirect_to folders_path
    else
      flash[:danger] = 'タイトルを入力して下さい'
      render :new
    end
  end

  def index
    @folders = current_user.folders
  end

  def show
    @recipes = @folder.recipes.order(updated_at: :desc)
    @folder_included_recipes = search_hit_recipe(@recipes)
  end

  def edit
  end

  def update
    if @folder.update(folder_params)
      redirect_to folders_path
    else
      flash[:danger] = 'タイトルを入力して下さい'
      render :edit
    end
  end

  def destroy
    @folder.destroy
    redirect_to folders_path
  end

  def add_recipe_select
    recipes = Recipe.not_included_folder(current_user.id, @folder.id)
    @choice_recipes = search_hit_recipe(recipes)
  end

  private

  def set_folder
    @folder = Folder.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:title).merge(user_id: current_user.id)
  end

  # 検索結果を返す(引数に絞り込みの対象を渡す)Gem:Ransack使用
  def search_hit_recipe(recipes)
    @q = recipes.ransack(params[:q])
    @q.result(distinct: true)
  end

  def user_match?
    folder = Folder.find(params[:id])
    redirect_to root_path unless current_user.id == folder.user_id
  end
end
