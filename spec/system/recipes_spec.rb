require 'rails_helper'

RSpec.describe "Recipes", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @ingredient = FactoryBot.create(:ingredient, recipe_id: @recipe.id)
    @recipe_ingredient = FactoryBot.build(:recipe_ingredient, user_id: @user.id)
    @folder = FactoryBot.create(:folder,user_id: @user.id)
  end

  context 'レシピ登録ができるとき' do 
    it '正しい情報を入力すればレシピと食材が登録できてレシピ登録画面に移動する' do
      # ログインする
      sign_in(@user)
      # レシピ登録ボタンがある
      expect(page).to have_content('レシピ登録')
      # レシピ登録ページに移動する
      visit new_recipe_path
      # フォームに情報を入力する
      fill_in 'タイトル(必須)', with: @recipe_ingredient.title
      fill_in '参考URL(任意)', with: @recipe_ingredient.source
      select '主菜', from: 'recipe_ingredient[category_id]'
      select 'お魚', from: 'recipe_ingredient[genre_id]'
      select 'あっさり', from: 'recipe_ingredient[type_id]'
      fill_in 'メイン食材(任意)', with: @recipe_ingredient.name
      fill_in '分量(任意)', with: @recipe_ingredient.amount
      select 'コ', from: '[recipe_ingredient][unit_id][]'
      # 登録するとRecipeモデルとIngredientのカウントが１上がる
      expect{
        find('input[name="commit"]').click
      }.to change{Recipe.count}.by(1).and change {Ingredient.count}.by(1)
      # 再びレシピ登録ページに戻っている
      expect(current_path).to eq new_recipe_path
    end
  end
  context 'レシピ登録ができない' do 
    it '正しい情報を入力すれば新規登録ができてトップページに移動する' do
      # ログインする
      sign_in(@user)
      # レシピ登録ボタンがある
      expect(page).to have_content('レシピ登録')
      # レシピ登録ページに移動する
      visit new_recipe_path
      # フォームに情報を入力する
      fill_in 'タイトル(必須)', with: ''
      fill_in '参考URL(任意)', with: ''
      fill_in 'メイン食材(任意)', with: ''
      fill_in '分量(任意)', with: ''
      select 'コ', from: '[recipe_ingredient][unit_id][]'
      # 登録してもRecipeモデルとIngredientのカウントは上がらない
      expect{
        find('input[name="commit"]').click
      }.to change{Recipe.count}.by(0).and change {Ingredient.count}.by(0)
      # 再びレシピ登録ページに戻っている
      expect(current_path).to eq new_recipe_path
    end
  end

  context 'レシピ一覧表示にできる' do 
    it 'レシピ一覧表示にアクセスすると登録済みのレシピ情報が表示される' do
      # ログインする
      sign_in(@user)
      # レシピ一覧ボタンが存在する
      expect(page).to have_content('レシピ一覧')
      # レシピ一覧表示ページに移動する
      visit recipes_path
      # レシピのタイトルが存在する
      expect(page).to have_content(@recipe.title)
      # レシピの参考サイトへのリンクが存在する
      expect(page).to have_link '参考サイトはこちら', href: @recipe.source
      # 食材名が存在する
      expect(page).to have_content(@ingredient.name)
      # 食材の分量が存在する
      expect(page).to have_content(@ingredient.amount.to_i).or have_content(@ingredient.amount)
    end
  end
  context 'レシピ一覧表示にアクセスできない' do 
    it 'ログアウト状態だとログイン画面へ遷移する' do
      # レシピ一覧表示へ移動する
      visit recipes_path
      # ログインページへ遷移している
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'レシピの編集ができるとき' do 
    it '編集画面から正しい情報を入力する' do
      # ログインする
      sign_in(@user)
      # レシピ一覧ボタンが存在する
      expect(page).to have_content('レシピ一覧')
      # レシピ一覧表示ページに移動する
      visit recipes_path
      # 編集ボタンがある
      expect(page).to have_content('編集')
      # 編集ページへ移動する 
      visit edit_recipe_path(@recipe)
      # レシピのタイトルが存在する
      expect(
        find('#recipe_title').value
      ).to eq(@recipe.title)
      # レシピの参考URLが存在する
      expect(
        find('#recipe_source').value
      ).to eq(@recipe.source)
      # フォルダの情報が存在する
      expect(page).to have_content(@folder.title)
      # レシピの情報を編集する
      fill_in 'タイトル', with: "#{@recipe.title}+編集"
      fill_in '参考URL(任意)', with: "#{@recipe.source}+編集"
      # 登録してもRecipeモデルのカウントは上がらない
      expect{
        click_on('登録')
      }.to change{Recipe.count}.by(0)
      # レシピ一覧ページに戻っていることを確認する
      expect(current_path).to eq recipes_path
      # 表示されているレシピのタイトルが変更されている
      expect(page).to have_content("#{@recipe.title}+編集")
      # 参考サイトへのリンクが変更されている
      expect(page).to have_link '参考サイトはこちら', href: "#{@recipe.source}+編集"
    end
  end
  context 'レシピの編集ができない時' do
    it '他人のレシピの編集画面へは遷移できない' do
      another_user = FactoryBot.create(:user)
      another_recipe = FactoryBot.create(:recipe, user_id: another_user.id)
      # ログインする
      sign_in(@user)
      # 他人のレシピの編集ページへ移動する
      visit edit_recipe_path(another_recipe)
      # トップページへリダイレクトしている
      expect(current_path).to eq root_path
    end
    it 'ログインしていないと編集画面へは遷移できない' do
      # トップページに移動する
      visit root_path
      # レシピ一覧のリンクは存在しない
      expect(page).to have_no_content('レシピ一覧')
      # レシピの編集ページへ移動する
      visit edit_recipe_path(@recipe)
      # ログインページへリダイレクトされる
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'レシピの削除ができる' do 
    it 'レシピ一覧表示から削除ボタンを押す' do
      # ログインする
      sign_in(@user)
      # レシピ一覧ボタンが存在する
      expect(page).to have_content('レシピ一覧')
      # レシピ一覧表示ページに移動する
      visit recipes_path
      # 登録済みのレシピ名が存在する
      expect(page).to have_content(@recipe.title)
      # 食材名が存在する
      expect(page).to have_content(@ingredient.name)
      # 食材の分量が存在する
      expect(page).to have_content(@ingredient.amount).or have_content(@ingredient.amount.to_i)
      # レシピの削除ボタンがある
      expect(page).to have_content('削除')
      # レシピの削除ボタンをクリックする
      click_on('レシピの削除')
      # レシピ一覧表示のページにいる
      expect(current_path).to eq recipes_path
      # レシピ名が存在しない
      expect(page).to have_no_content(@recipe.title)
      # 食材名が存在しない
      expect(page).to have_no_content(@ingredient.name)
      # 食材の分量が存在しない
      expect(page).to have_no_content(@ingredient.amount).and have_no_content(@ingredient.amount.to_i)
    end
  end
end
