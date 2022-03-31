class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  has_many :ingredients, dependent: :destroy
  has_many :lists, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :genre
  belongs_to :type

  def self.match_recipe(dates)
    hash = {}
    dates.each{|key, value|
      unless value.blank?
        hash[key] = value
      end
    }
    Recipe.where(hash)
  end

  def self.random(dates)
    recipes = Recipe.match_recipe(dates)
    num = rand(recipes.length) - 1
    return recipes[num]
  end
end
