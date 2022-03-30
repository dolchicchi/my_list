class AddColumnRecipe < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :category_id, :integer
    add_column :recipes, :genre_id, :integer
    add_column :recipes, :type_id, :integer
  end
end
