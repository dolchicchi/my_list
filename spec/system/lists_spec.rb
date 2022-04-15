require 'rails_helper'

RSpec.describe "Lists", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @list = FactoryBot.build(:list)
    sleep 0.02
  end

  context '新規登録できる時' do
    it '新規登録画面からレシピを選択して登録ボタンを押す' do
      # ログインしてトップページに移動する
      sign_in(@user)
      # レシピ名はまだ存在しない
      expect(page).to have_no_content(@recipe.title)
      # 追加ボタンが存在する
      expect(page).to have_content('追加')
      # 新規登録ページに移動する
      visit new_list_path(date: @list.date)
      # レシピ名が表示されている
      expect(page).to have_content(@recipe.title)
      # レシピを選択する
      choose @recipe.title
      # 登録ボタンを押すとListモデルのカウントが1上がる
      expect{
        click_on('登録')
      }.to change{List.count}.by(1)
      # トップページに戻っている
      expect(current_path).to eq lists_path
      # 戻ったトップページに登録したレシピ名が表示されている
      expect(page).to have_content(@recipe.title)
    end
  end
  context '新規登録できない時' do
    it '選択せずに登録ボタンを押す' do
      # ログインしてトップページに移動する
      sign_in(@user)
      # 追加ボタンが存在する
      expect(page).to have_content('追加')
      # 新規登録ページに移動する
      visit new_list_path(date: @list.date)
      # レシピ名が表示されている
      expect(page).to have_content(@recipe.title)
      # 登録ボタンを押してもListモデルのカウントは上がらない
      expect{
        click_on('登録')
      }.to change{List.count}.by(0)
      # トップページに戻っている
      expect(current_path).to eq new_list_path
    end
  end

  context '一覧ページに登録したレシピが表示されている' do
    it 'トップページに移動すると登録済みListデータが表示されている' do
      @list = FactoryBot.create(:list, user_id: @user.id, recipe_id: @recipe.id)
      # ログインしてトップページに移動する
      sign_in(@user)
      # 登録済みのレシピが表示されている
      expect(page).to have_content(@recipe.title)
    end
  end

  context '献立に登録済みのレシピを削除できる' do
    it 'ログインした状態で削除ボタンをクリックする' do
      @list = FactoryBot.create(:list, user_id: @user.id, recipe_id: @recipe.id)
      # ログインしてトップページに移動する
      sign_in(@user)
      # 登録済みのレシピが表示されている
      expect(page).to have_content(@recipe.title)
      # 削除ボタンが表示されている
      expect(page).to have_content('削除')
      # 削除ボタンをクリックする
      click_on('削除')
      # 一覧表示ページに遷移している
      expect(current_path).to eq lists_path
      # 一覧表示からレシピ名が消えている
      expect(page).to have_no_content(@recipe.title)
    end
  end

  context 'おまかせ機能で１週間分の献立が登録できる' do
    it 'レシピ情報を１件以上登録した状態でおまかせボタンを押す' do
      # ログインしてトップページに移動する
      sign_in(@user)
      # レシピ名は存在していない
      expect(page).to have_no_content(@recipe.title)
      # おまかせメニューボタンがある
      expect(page).to have_button 'おまかせメニュ〜'
      # おまかせメニューボタンをクリックする
      click_on('おまかせメニュ〜')
      # 非表示だった一週間おまかせボタンが表示される
      expect(page).to have_button '一週間おまかせ'
      # おまかせボタンをクリックするとListテーブルのカウントが７上がる
      expect{
        click_on('一週間おまかせ')
      }.to change{List.count}.by(7)
      # トップページにリダイレクトしている
      expect(current_path).to eq root_path
      # レシピ名が表示されている
      expect(page).to have_content(@recipe.title)
    end
  end
  context 'おまかせボタンで一週間分の献立が登録できない' do
    it '登録済みのレシピが１件もないと何も登録されない' do
      another_user = FactoryBot.create(:user)
      # ログインしてトップページに移動する
      sign_in(another_user)
      # おまかせメニューボタンがある
      expect(page).to have_button 'おまかせメニュ〜'
      # おまかせメニューボタンをクリックする
      click_on('おまかせメニュ〜')
      # 非表示だった一週間おまかせボタンが表示される
      expect(page).to have_button '一週間おまかせ'
      # おまかせボタンをクリックしてもListテーブルのカウントは上がらない
      expect{
        click_on('一週間おまかせ')
      }.to change{List.count}.by(0)
      # トップページにリダイレクトしている
      expect(current_path).to eq root_path
    end
  end

  context 'おまかせボタンで指定の日にランダムで献立登録できる' do
    it '日付を指定しておまかせボタンを押すと献立を１件登録できる' do
      today = Date.today
      # ログインする
      sign_in(@user)
      # レシピ名は存在しない
      expect(page).to have_no_content(@recipe.title)
      # おまかせメニューボタンがある
      expect(page).to have_button 'おまかせメニュ〜'
      # おまかせメニューボタンをクリックする
      click_on('おまかせメニュ〜')
      # 日付の選択フォームがある
      expect(page).to have_css('#random-menu-date')
      # 非表示だった一週間おまかせボタンが表示される
      expect(page).to have_button '一週間おまかせ'
      # おまかせボタンは存在しない
      expect(page).to have_no_content('おまかせ')
      # 日付を指定する
      find('input[name="list[date]"]').set(today)
      # 一週間おまかせボタンがおまかせボタンに変化している
      expect(page).to have_no_content('一週間おまかせ')
      expect(page).to have_button 'おまかせ'
      # おまかせボタンをクリックするとListテーブルのカウントが１上がる
      expect{
        click_on('おまかせ')
      }.to change{List.count}.by(1)
      # トップページにリダイレクトしている
      expect(current_path).to eq root_path
      # レシピ名が存在する
      expect(page).to have_content(@recipe.title)
    end
  end

  context '取り消しボタンを押すと７件削除される' do
    it '７件登録がある状態で削除を押す' do
      # ログインしてトップページに移動する
      sign_in(@user)
      # レシピ名は存在していない
      expect(page).to have_no_content(@recipe.title)
      # おまかせメニューボタンがある
      expect(page).to have_button 'おまかせメニュ〜'
      # おまかせメニューボタンをクリックする
      click_on('おまかせメニュ〜')
      # 非表示だった一週間おまかせボタンが表示される
      expect(page).to have_button '一週間おまかせ'
      # 非表示だった取り消しボタンが表示される
      expect(page).to have_link '取り消し'
      # おまかせボタンをクリックするとListテーブルのカウントが７上がる
      expect{
        click_on('一週間おまかせ')
      }.to change{List.count}.by(7)
      # トップページにリダイレクトしている
      expect(current_path).to eq root_path
      # レシピ名が表示されている
      expect(page).to have_content(@recipe.title)
      # おまかせメニューボタンをクリックする
      click_on('おまかせメニュ〜')
      #  直近７件削除ボタンを押す
      click_on('取り消し')
      # レシピ名が消えている
      expect(page).to have_no_content(@recipe.title)
    end
  end
end
