class Genre < ActiveHash::Base
  self.data = [
    { id: 1, name: 'お肉' },
    { id: 2, name: 'お魚' },
    { id: 3, name: '野菜' },
    { id: 4, name: 'その他' }
  ]
 
   include ActiveHash::Associations
   has_many :recipes
 
  end