class AddFolderRecipes < ActiveRecord::Migration[6.0]
  def change
    add_reference :recipes, :folder, foreign_key: true
  end
end
