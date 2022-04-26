class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  has_many :ingredients, dependent: :destroy
  has_many :lists, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :genre
  belongs_to :type

  validates :title, presence: true

  def self.match_recipes(datas)
    hash = {}
    datas.each  do |key, value|
      hash[key] = value unless value.blank?
    end
    Recipe.where(hash)
  end

  def self.random(datas)
    recipes = Recipe.match_recipes(datas)
    num = rand(recipes.length) - 1
    recipes[num]
  end

  def self.not_included_folder(current_user_id, params_id)
    Recipe.where(user_id: current_user_id).where.not(folder_id: params_id)
          .or(
            Recipe.where(user_id: current_user_id, folder_id: nil)
          )
  end

  def self.weekly_recipes_data(weekly_datas)
    weekly_recipes = []
    weekly_datas.each do |day_data|
      weekly_recipes << day_data.recipe
    end
    weekly_recipes
  end
end
