class Type < ActiveHash::Base
  self.data = [
    { id: 4, name: 'がっつり' },
    { id: 3, name: 'その他' },
    { id: 2, name: 'あっさり' },
    { id: 1, name: 'こってり' }
  ]

  include ActiveHash::Associations
  has_many :recipes
end