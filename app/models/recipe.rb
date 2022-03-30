class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  has_many :ingredients, dependent: :destroy
  has_many :lists, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :genre
  belongs_to :type
end
