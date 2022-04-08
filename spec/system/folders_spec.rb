require 'rails_helper'

RSpec.describe "Folders", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @folder = FactoryBot.create(:folder, user_id: @user.id)
    sleep 0.02
  end

  context 'フォルダの新規登録ができる' do
    it '入力を正しく行い送信したら登録できる' do
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # フォルダの新規作成ボタンがある
      expect(page).to have_link('フォルダの新規作成')
      # フォルダの新規作成ページへ移動する
      visit new_folder_path
      # 情報を入力する 
      fill_in 'タイトル(必須)', with: @folder.title
      # 登録ボタンを押すとForderのカウントが１上がる
      expect{
        click_on('登録')
      }.to change{Folder.count}.by(1)
      # 一覧表示ページに遷移している
      expect(current_path).to eq folders_path
    end
  end
  context 'フォルダの新規登録ができない' do
    it '正しく入力していない状態で送信しても登録できない' do
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # フォルダの新規作成ボタンがある
      expect(page).to have_link('フォルダの新規作成')
      # フォルダの新規作成ページへ移動する
      visit new_folder_path
      # 情報を入力する 
      fill_in 'タイトル(必須)', with: ''
      # 登録ボタンを押してもForderのカウントは上がらない
      expect{
        click_on('登録')
      }.to change{Folder.count}.by(0)
      # 新規作成画面へリダイレクトしている
      expect(current_path).to eq folders_path
    end
  end

  context '一覧ページにフォルダ名が表示されている' do
    it '一覧ページに移動すると登録済みのフォルダのタイトルが表示されている' do
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # 作成済みのフォルダ名が表示されている
      expect(page).to have_content(@folder.title)
    end
  end

  context 'フォルダ名を編集できる' do
    it '情報を正しく入力して送信すると変更できる' do
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # 作成済みのフォルダ名が表示されている
      expect(page).to have_content(@folder.title)
      # フォルダ名の編集ボタンがある
      expect(page).to have_link('フォルダ名の編集')
      # 編集画面に移動する
      visit edit_folder_path(@folder)
      # フォルダ名が表示されている
      expect(
        find('#folder_title').value
      ).to eq(@folder.title)
      # フォルダ名を変更する
      fill_in 'タイトル', with: "#{@folder.title}編集"
      # 登録してもFolderモデルのカウントは上がらない
      expect{
        click_on('登録')
      }.to change{Folder.count}.by(0)
      # 一覧表示ページにリダイレクトしている
      expect(current_path).to eq folders_path
      # 変更したフォルダ名が表示されている
      expect(page).to have_content("#{@folder.title}編集")
    end
  end
  context 'フォルダ名が編集できない' do
    it '正しく入力されていないと送信しても変更できない' do
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # 作成済みのフォルダ名が表示されている
      expect(page).to have_content(@folder.title)
      # フォルダ名の編集ボタンがある
      expect(page).to have_link('フォルダ名の編集')
      # 編集画面に移動する
      visit edit_folder_path(@folder)
      # フォルダ名が表示されている
      expect(
        find('#folder_title').value
      ).to eq(@folder.title)
      # フォルダ名を変更する
      fill_in 'タイトル', with: ''
      # 登録してもFolderモデルのカウントは上がらない
      expect{
        click_on('登録')
      }.to change{Folder.count}.by(0)
      # リダイレクトされている
      expect(current_path).to eq folder_path(@folder)
    end
  end
  
  context 'フォルダの削除ができる' do
    it '一覧表示ページからフォルダを削除できる' do
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # 作成済みのフォルダ名が表示されている
      expect(page).to have_content(@folder.title)
      # フォルダの削除ボタンがある
      expect(page).to have_link('フォルダの削除')
      # フォルダの削除ボタンを押す
      click_on('フォルダの削除')
      # 一覧表示ページに戻っている
      expect(current_path).to eq folders_path
      # フォルダ名が表示されていない
      expect(page).to have_no_content(@folder.title)
    end
  end

  context 'レシピの追加ができる' do
    it '正しい情報を送信するとフォルダにレシピを追加できる' do
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # レシピの追加ボタンがある
      expect(page).to have_link('レシピの追加')
      # レシピの追加ページに移動する
      visit add_recipe_select_folder_path(@folder)
      # レシピ名が表示されている
      expect(page).to have_content(@recipe.title) 
      # レシピを選択する
      check @recipe.title
      # 追加ボタンを押す
      click_on('追加')
      # フォルダ詳細ページに移動する
      expect(current_path).to eq folder_path(@folder)
      # 選択肢たレシピ名が詳細ページで表示されている
      expect(page).to have_content(@recipe.title)
    end
  end
  context 'レシピの追加ができない' do
    it 'レシピを選択せずに追加ボタンを押しても画面遷移しない' do
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # レシピの追加ボタンがある
      expect(page).to have_link('レシピの追加')
      # レシピの追加ページに移動する
      visit add_recipe_select_folder_path(@folder)
      # レシピ名が表示されている
      expect(page).to have_content(@recipe.title) 
      # 追加ボタンを押す
      click_on('追加')
      # 追加ページに留まっている
      expect(current_path).to eq add_recipe_select_folder_path(@folder)
    end
  end

  context 'フォルダの詳細ページに登録済みのレシピが表示されている' do
    it 'レシピをフォルダに登録している状態で詳細ページを開く' do
      another_recipe = FactoryBot.create(:recipe, user_id: @user.id, folder_id: @folder.id)
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # フォルダ名が表示された詳細ページへのリンクがある
      expect(page).to have_link @folder.title
      # 詳細ページに移動する
      visit folder_path(@folder)
      # 登録済みのレシピ名が表示されている
      expect(page).to have_content(another_recipe.title)
    end
  end

  context 'フォルダから登録済のレシピのレシピを削除できる' do
    it '詳細ページでフォルダから削除ボタンを押す' do
      another_recipe = FactoryBot.create(:recipe, user_id: @user.id, folder_id: @folder.id)
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # フォルダ名が表示された詳細ページへのリンクがある
      expect(page).to have_link @folder.title
      # 詳細ページに移動する
      visit folder_path(@folder)
      # 登録済みのレシピ名が表示されている
      expect(page).to have_content(another_recipe.title)
      # フォルダから削除ボタンがある
      expect(page).to have_link('フォルダから削除')
      # フォルダから削除ボタンをクリックする
      click_on('フォルダから削除')
      # レシピ名が表示されていない
      expect(page).to have_no_content(another_recipe.title)
    end
  end

  context '詳細ページから献立登録ができる' do
    it 'レシピと日付を選択して送信すると登録できる' do
      another_recipe = FactoryBot.create(:recipe, user_id: @user.id, folder_id: @folder.id)
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # フォルダ名が表示された詳細ページへのリンクがある
      expect(page).to have_link @folder.title
      # 詳細ページに移動する
      visit folder_path(@folder)
      # 登録済みのレシピ名が表示されている
      expect(page).to have_content(another_recipe.title)
      # レシピを選択する
      choose another_recipe.title
      # 日付を選択する
      find('input[name="date"]').set(Date.today)
      # 献立へ追加ボタンをクリックするとListカウントが１上がる
      expect{
        click_on('献立へ追加')
      }.to change{List.count}.by(1)
      # トップページに遷移している
      expect(current_path).to eq lists_path
    end
  end
  context '詳細ページから献立登録ができない' do
    it 'レシピを選択していないと献立登録されない' do
      another_recipe = FactoryBot.create(:recipe, user_id: @user.id, folder_id: @folder.id)
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # フォルダ名が表示された詳細ページへのリンクがある
      expect(page).to have_link @folder.title
      # 詳細ページに移動する
      visit folder_path(@folder)
      # 登録済みのレシピ名が表示されている
      expect(page).to have_content(another_recipe.title)
      # 日付を選択する
      find('input[name="date"]').set(Date.today)
      # 献立へ追加ボタンをクリックしてもカウントは上がらない
      expect{
        click_on('献立へ追加')
      }.to change{List.count}.by(0)
      # 詳細ページにいる
      expect(current_path).to eq folder_path(@folder)
    end
    it '日付を選択していないと献立登録されない' do
      another_recipe = FactoryBot.create(:recipe, user_id: @user.id, folder_id: @folder.id)
      # ログインする
      sign_in(@user)
      # フォルダ一覧ボタンがある
      expect(page).to have_link('フォルダ一覧')
      # フォルダ一覧表示ページへ移動する
      visit folders_path
      # フォルダ名が表示された詳細ページへのリンクがある
      expect(page).to have_link @folder.title
      # 詳細ページに移動する
      visit folder_path(@folder)
      # 登録済みのレシピ名が表示されている
      expect(page).to have_content(another_recipe.title)
      # レシピを選択する
      choose another_recipe.title
      # 献立へ追加ボタンをクリックしてもカウントは上がらない
      expect{
        click_on('献立へ追加')
      }.to change{List.count}.by(0)
      # 詳細ページにいる
      expect(current_path).to eq folder_path(@folder)
    end
  end
end
