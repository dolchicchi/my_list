class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :folder
  has_many :ingredients, dependent: :destroy
  has_many :lists, dependent: :destroy
end
