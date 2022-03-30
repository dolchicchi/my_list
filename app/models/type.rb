class Type < ActiveHash::Base
  self.data = [
    { id: 1, name: 'こってり' },
    { id: 2, name: 'あっさり' },
    { id: 3, name: 'その他' }
  ]

  include ActiveHash::Associations
  has_many :recipes
end