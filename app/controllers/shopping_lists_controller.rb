class ShoppingListsController < ApplicationController
  before_action :shopping_lists, only: :index

  def index

  end

  private
  # 当日より一週間のデータを取得
  def weekly_dates
    @today = Date.today
    @weekly_dates = current_user.lists.where(date: @today..@today + 7).order(date: :asc)
  end

  # 一週間のデータからレシピの情報のみ取得
  def weekly_recipes
    @weekly_recipes = []
    weekly_dates.each do |day_date|
      @weekly_recipes << day_date.recipe
    end
    return @weekly_recipes
  end

  # 一週間のレシピに紐づく食材のデータを単次元配列にまとめる
  def ingredients_index
    @weekly_ingredient = []
    weekly_recipes.each do |day_recipe|
      @weekly_ingredient << day_recipe.ingredients
    end
    return @weekly_ingredient.flatten!
  end

  # 一週間分の食材のデータから食材名のみを配列にまとめる
  def ingredients_name_index
    @ingredients_name_index = []
    ingredients_index.each do |ingredient|
      @ingredients_name_index << ingredient.name
    end
    return @ingredients_name_index.uniq!
  end

  # 一週間分の食材のデータを {食材名 => 分量, unit_id => unit_id}のハッシュになるように変換し配列へ入れる
  def weekly_ingredients_hash
    @weekly_ingredients_hash = []
    ingredients_index.each do |ingredient|
      hash = {}
      hash[ingredient.name] = ingredient.amount
      hash["unit_id"] = ingredient.unit_id
      @weekly_ingredients_hash << hash
    end
    return @weekly_ingredients_hash
  end

# 一週間分の食材のデータを {食材名 => 単位名(グラム コなど)}になるように変換
  def weekly_ingredients_unit
    @weekly_ingredients_unit = {}
    ingredients_index.each do |index|
      @weekly_ingredients_unit[index.name] = index.unit.name
    end
    return @weekly_ingredients_unit
  end

# weekly_ingredients_hashを食材名ごとに分量を合計してまとめて単位を追加する
  def shopping_lists
    @shopping_lists = []
    ingredients_name_index.each do |key|
      hash = {}
      hash[key] = weekly_ingredients_hash.map{|h| h[key]}.compact!.sum
      hash[:unit] = weekly_ingredients_unit[key]
      @shopping_lists << hash
    end
    return @shopping_lists
  end
end
