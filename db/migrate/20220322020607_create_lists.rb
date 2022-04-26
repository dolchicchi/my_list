class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.date       :date,   null: false
      t.references :user,   null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.timestamps
    end
  end
end
