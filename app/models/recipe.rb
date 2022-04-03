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

  def self.match_recipes(dates)
    hash = {}
    dates.each{|key, value|
      unless value.blank?
        hash[key] = value
      end
    }
    Recipe.where(hash)
  end

  def self.random(dates)
    recipes = Recipe.match_recipes(dates)
    num = rand(recipes.length) - 1
    return recipes[num]
  end

  def self.not_included_folder(current_user_id, params_id)
    Recipe.where(user_id: current_user_id).where.not(folder_id: params_id)
    .or(
    Recipe.where(user_id: current_user_id).where(folder_id: nil)
    )
  end

  def self.weekly_recipes_date(weekly_dates)
    weekly_recipes = []
    weekly_dates.each do |day_date|
      weekly_recipes << day_date.recipe
    end
    return weekly_recipes
  end
end
