# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_220_330_072_800) do
  create_table 'folders', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'title', null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['user_id'], name: 'index_folders_on_user_id'
  end

  create_table 'ingredients', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name', null: false
    t.float 'amount'
    t.integer 'unit_id'
    t.bigint 'recipe_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['recipe_id'], name: 'index_ingredients_on_recipe_id'
  end

  create_table 'lists', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.date 'date', null: false
    t.bigint 'user_id', null: false
    t.bigint 'recipe_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['recipe_id'], name: 'index_lists_on_recipe_id'
    t.index ['user_id'], name: 'index_lists_on_user_id'
  end

  create_table 'recipes', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'title', null: false
    t.text 'source'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'folder_id'
    t.integer 'category_id'
    t.integer 'genre_id'
    t.integer 'type_id'
    t.index ['folder_id'], name: 'index_recipes_on_folder_id'
    t.index ['user_id'], name: 'index_recipes_on_user_id'
  end

  create_table 'users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'nickname', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'folders', 'users'
  add_foreign_key 'ingredients', 'recipes'
  add_foreign_key 'lists', 'recipes'
  add_foreign_key 'lists', 'users'
  add_foreign_key 'recipes', 'folders'
  add_foreign_key 'recipes', 'users'
end
