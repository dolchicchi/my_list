class Folder < ApplicationRecord
  has_many :recipes, dependent: :nullify
  belongs_to :user
end
