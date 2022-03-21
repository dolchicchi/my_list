class RenameStringColumnToIngredients < ActiveRecord::Migration[6.0]
  def change
    rename_column :ingredients, :string, :name
  end
end
