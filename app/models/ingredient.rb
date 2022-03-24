class Ingredient < ApplicationRecord
  belongs_to :recipe
  
  with_options presence: true do
   validates :name
   validates :amount
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :unit
end
