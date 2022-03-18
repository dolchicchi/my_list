class Recipe < ApplicationRecord
  belongs_to :user
  has_one :ingredient
  
end
