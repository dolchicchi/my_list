class Ingredient < ApplicationRecord
  belongs_to :recipe

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :unit
end
