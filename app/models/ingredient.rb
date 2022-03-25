class Ingredient < ApplicationRecord
  belongs_to :recipe
  
  with_options presence: true do
   validates :name
   validates :amount, numericality: { only_integer: true }
  end
  validates :unit_id, numericality: { other_than: 1 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :unit
end
 