class Category < ActiveHash::Base
  self.data = [
    { id: 1, name: '主菜' },
    { id: 2, name: '副菜' },
    { id: 3, name: 'スープ' },
    { id: 5, name: 'サラダ' },
    { id: 4, name: 'その他' }
  ]

  include ActiveHash::Associations
  has_many :recipes
end
