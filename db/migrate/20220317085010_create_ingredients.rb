class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string     :string, null: false
      t.integer    :amount
      t.integer    :unit_id
      t.references :recipe, null: false, foreign_key: true
      t.timestamps
    end
  end
end
