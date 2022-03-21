class ListsController < ApplicationController
  def index
  end

  def new
    @today = Date.today
  end


end
