class ChangeDatatypeAmountOfIngredients < ActiveRecord::Migration[6.0]
  def change
    change_column :ingredients, :amount, :float
  end
end
