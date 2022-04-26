class IngredientsController < ApplicationController
  before_action :new_ingredient, only: %i[new create]
  before_action :recipe_set, only: %i[new create edit update]
  before_action :user_check, only: :edit
  before_action :ingredient_set, only: %i[edit update destroy]

  def new
  end

  def create
    ingredient_create_data_ary.each do |ingredient_data|
      ingredient = Ingredient.new(ingredient_data)
      next if ingredient.save

      flash[:danger] = '正しく入力して下さい'
      render :new
      return
    end
    flash[:message] = '登録しました'
    redirect_to recipes_path
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_edit_datas)
      redirect_to recipes_path
    else
      flash[:danger] = '正しく入力して下さい'
      render :edit
    end
  end

  def destroy
    @ingredient.destroy
    flash[:message] = '削除しました'
    redirect_to recipes_path
  end

  private

  def new_ingredient
    @ingredient = Ingredient.new
  end

  def user_check
    redirect_to root_path unless current_user.id == @recipe.user_id
  end

  def ingredient_set
    @ingredient = Ingredient.find(params[:id])
  end

  def recipe_set
    @recipe = Recipe.find(params[:recipe_id])
  end

  # 一回のリクエストで複数のレコードに保存するための処理 2
  # データ保存できる形のハッシュを作り配列に格納
  def ingredient_create_data_ary
    ingredients_params = params_shape_change
    ary = []
    ingredients_params.each do |ingredient_params|
      header = %w[name amount unit_id]
      ingredient_parameter = Hash[header.zip(ingredient_params)]
      ingredient_parameter['recipe_id'] = params[:recipe_id]
      ary << ingredient_parameter
    end
    ary
  end

  # 一回のリクエストで複数のレコードに保存するための処理 1
  # 送られてきた配列のパラメーターをname amount unit_id 一つずつ取り出して配列に格納
  def params_shape_change
    params[:recipe_ingredient][:amount].each do |amount|
      amount.tr!('０-９', '0-9')
    end

    [
      params[:recipe_ingredient][:name],
      params[:recipe_ingredient][:amount],
      params[:recipe_ingredient][:unit_id]
    ].transpose
  end

  def ingredient_edit_datas
    params[:ingredient][:amount].tr!('０-９', '0-9')
    params.require(:ingredient).permit(:name, :amount, :unit_id).merge(recipe_id: params[:recipe_id])
  end
end
