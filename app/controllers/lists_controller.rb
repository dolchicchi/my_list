class ListsController < ApplicationController
  def index
  end

  def new
    @today = Date.today
  end

  def select
    @list = List.new
    @recipe_lists = Recipe.all
    @date = params[:date]
  end

  def create
    list = List.new(list_params)
    if list.save
      redirect_to new_list_path
    end
  end

  private
  def list_params
    params.require(:list).permit(:recipe_id).merge(user_id: current_user.id, date: params[:date])
  end

end
