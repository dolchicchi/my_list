class FoldersController < ApplicationController
  # before_action :set_search, only: :show
  before_action :select_recipes, only: :add_recipe_select
  before_action :set_folder, only: [:show, :edit, :destroy, :update, :add_recipe_select]
  
  def new
    @folder = Folder.new
  end

  def create
    folder = Folder.new(folder_params)
    if folder.save
      redirect_to folders_path
    else
      render :new
    end
  end

  def index
    @folders = current_user.folders
  end

  def show
    @recipes = @folder.recipes.order(updated_at: :desc)
    @q = @recipes.ransack(params[:q])
    @search_folder_recipes = @q.result(distinct: true)
  end

  def edit
  end

  def update
    if @folder.update(folder_params)
      redirect_to folders_path
    else
      render edit
    end
  end

  def destroy
    @folder.destroy
    redirect_to folders_path
  end

  def add_recipe_select

  end

  def add_recipe
    add_recipe_date
    @recipe_ids.each do |recipe_id|
      recipe = Recipe.find(recipe_id)
      unless recipe.update(@folder_id)
        render :add_recipe_select
        return
      end
    end
    redirect_to folder_path(params[:id])
  end


  
  private
  def set_folder
    @folder = Folder.find(params[:id])
  end

  def add_recipe_date
    @recipe_ids = params.require(:folder).permit(recipe_ids: [])[:recipe_ids]
    @folder_id = {folder_id: params[:id]}
  end

  def folder_params
    params.require(:folder).permit(:title).merge(user_id: current_user.id)
  end

  def select_recipes
    @recipes = 
    Recipe.where(user_id: current_user.id).where.not(folder_id: params[:id])
    .or(
      Recipe.where(user_id: current_user.id).where(folder_id: nil)
    )
    @q = @recipes.ransack(params[:q])
    @select_recipes = @q.result(distinct: true)
  end
end
