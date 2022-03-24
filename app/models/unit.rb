class Unit < ActiveHash::Base
  self.data = [
    {id: 1, name: '---'},
    {id: 2, name: 'グラム'},
    {id: 3, name: 'コ'},
    {id: 4, name: '本'},
    {id: 5, name: '束'},
    {id: 6, name: 'cc'},
    {id: 7, name: 'カップ'}
  ]

  include ActiveHash::Associations
  has_many :ingredients

end