class ShoppingListsController < ApplicationController
  before_action :data_check, only: :index

  def index
    @shopping_lists = []
    weekly_ingredients_name_ary.each do |ingredient_name|
      hash = {}
      hash[ingredient_name] = weekly_ingredients_hashs.map{|h| h[ingredient_name]}.compact.sum
      hash[:unit] = weekly_ingredients_unit[ingredient_name]
      @shopping_lists << hash
    end
  end

  private
  # 一週間の献立が空の時はリダイレクト
  def data_check
    if weekly_datas.empty?
      flash[:danger] = "一件以上の献立登録が必要です。"
      redirect_to root_path
    end
  end

  # 当日より一週間の献立データListテーブルから取得
  def weekly_datas
    List.weekly_lists(current_user.id).includes(recipe: :ingredients)
  end

  # 一週間の献立データに紐づくレシピの情報を取得して配列にまとめるメソッドを使用
  def weekly_recipes
    Recipe.weekly_recipes_data(weekly_datas)
  end

  # 一週間のレシピに紐づく食材のデータを単次元配列にまとめるメソッドを使用
  def weekly_ingredients
    Ingredient.weekly_ingredients_data(weekly_recipes)
  end

  # 一週間分の食材のデータから食材名のみを配列にまとめる
  def weekly_ingredients_name_ary
    ary = []
    weekly_ingredients.each do |ingredient|
      ary << ingredient.name
    end
    return ary.uniq
  end

  # 一週間分の食材のデータを {食材名 => 分量, unit_id => unit_id}のハッシュになるように変換し配列へ入れる
  def weekly_ingredients_hashs
    hashs_ary = []
    weekly_ingredients.each do |ingredient|
      hash = {}
      hash[ingredient.name] = ingredient.amount
      hash["unit_id"] = ingredient.unit_id
      hashs_ary << hash
    end
    return hashs_ary
  end

# 一週間分の食材のデータを {食材名 => 単位名(グラム コなど)}になるようハッシュを生成
  def weekly_ingredients_unit
    hash = {}
    weekly_ingredients.each do |ingredient|
      hash[ingredient.name] = ingredient.unit.name
    end
    return hash
  end
end
