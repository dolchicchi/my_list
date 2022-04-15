require 'rails_helper'

RSpec.describe "Ingredients", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @ingredient = FactoryBot.create(:ingredient, recipe_id: @recipe.id)
  end

  context '材料の新規作成ができる' do
    it '情報が正しく入力されていれば材料の追加ができる' do
      another_ingredient = FactoryBot.build(:ingredient, recipe_id: @recipe.id)
      # ログインする
      sign_in(@user)
      # レシピ一覧表示のボタンがある
      expect(page).to have_content('レシピ一覧')
      # レシピ一覧表示ページへ移動する
      visit recipes_path
      # 材料の追加ボタンがある
      expect(page).to have_content('材料の追加')
      # 材料の追加ページへ移動する
      visit new_recipe_ingredient_path(@recipe)
      # 材料の情報を入力する
      fill_in '食材名', with: another_ingredient.name
      fill_in '分量', with: another_ingredient.amount
      select 'コ', from: '[recipe_ingredient][unit_id][]'
      # 登録を押すとIngredientモデルのカウントが1上がる
      expect{
        click_on('登録')
      }.to change{Ingredient.count}.by(1)
      # レシピ一覧表示のページに戻っている
      expect(current_path).to eq recipes_path
    end
  end
  context '材料の新規作成ができない' do
    it '情報が正しく入力されていないと登録できない' do
      # ログインする
      sign_in(@user)
      # レシピ一覧表示のボタンがある
      expect(page).to have_content('レシピ一覧')
      # レシピ一覧表示ページへ移動する
      visit recipes_path
      # 材料の追加ボタンがある
      expect(page).to have_content('材料の追加')
      # 材料の追加ページへ移動する
      visit new_recipe_ingredient_path(@recipe)
      # 材料の情報を入力する
      fill_in '食材名', with: ''
      fill_in '分量', with: ''
      # 登録を押してもIngredientモデルのカウントが上がらない
      expect{
        click_on('登録')
      }.to change{Ingredient.count}.by(0)
      # レシピ一覧表示のページに戻っている
      expect(current_path).to eq recipe_ingredients_path(@recipe)
    end
    it 'ログインしていないとログイン画面に遷移する' do
      # 新規作成画面にアクセスする
      visit new_recipe_ingredient_path(@recipe)
      # ログインページに遷移している
      expect(current_path).to eq new_user_session_path
    end
  end

  context '食材の編集ができる' do
    it '情報を正しく入力すると保存できる' do
      # ログインしてレシピ一覧ページに移動する
      sign_in_visit_recipes(@user)
      # 修正ボタンがある
      expect(page).to have_content('修正')
      # 編集ページへ移動する
      visit edit_recipe_ingredient_path(@recipe, @ingredient)
      # 食材名が表示されている
      expect(
        find('#ingredient_name').value
      ).to eq(@ingredient.name)
      # 食材の分量が表示されている
      expect(
        find('#ingredient_amount').value
      ).to eq(@ingredient.amount.to_s)
      # 食材の情報を編集する
      fill_in '食材名', with: "#{@ingredient.name}編集"
      fill_in '分量', with: @ingredient.amount + 1
      # 追加ボタンを押してもIngredientモデルのカウントは上がらない
      expect{
        click_on('修正')
      }.to change{Ingredient.count}.by(0)
      # レシピ一覧ページに遷移している
      expect(current_path).to eq recipes_path
    end
  end
  context '食材の編集ができない' do
    it '情報が正しく入力できていないと保存できない' do
      # ログインしてレシピ一覧ページに移動する
      sign_in_visit_recipes(@user)
      # 修正ボタンがある
      expect(page).to have_content('修正')
      # 編集ページへ移動する
      visit edit_recipe_ingredient_path(@recipe, @ingredient)
      # 情報を空にする
      fill_in '食材名', with: ''
      fill_in '分量', with: ''
      # 登録ボタンを押す
      click_on('修正')
      # 編集ページにリフダイレクトされる
      expect(current_path).to eq recipe_ingredient_path(@recipe, @ingredient)
    end
  end

  context '食材の削除ができる' do
    it '削除ボタンをクリックすると削除できる' do
      # ログインしてレシピ一覧ページに移動する
      sign_in_visit_recipes(@user)
      # 食材名がある
      expect(page).to have_content(@ingredient.name)
      # 食材の分量がある
      expect(page).to have_content(@ingredient.amount).or have_content(@ingredient.amount.to_i)
      # 削除ボタンを押す
      click_on('削除')
      # レシピ一覧ページにいる
      expect(current_path).to eq recipes_path
      # 食材名が消えている
      expect(page).to have_no_content(@ingredient.name)
      # 食材の分量が消えている
      expect(page).to have_no_content(@ingredient.amount).and have_no_content(@ingredient.amount.to_i)
    end
  end
end
