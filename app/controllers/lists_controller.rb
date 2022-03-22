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

  private
  def list_params
    params.require(:list).permit(:recipe_id).merge(user_id: current_user.id, date: params[:date])
  end

  def set_lists
    @today = Date.today
    @lists = current_user.lists.where(date: @today..@today + 7)
  end

end
