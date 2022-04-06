require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # ログインページへ遷移していることを確認する
      expect(current_path).to eq(new_user_session_path)
      # 新規登録ボタンが存在する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit  new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ニックネーム', with: @user.nickname
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      fill_in 'パスワード(確認用)', with: @user.password
      # 登録ボタンを押すとユーザーモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログアウトボタンが表示されている
      expect(page).to have_content('ログアウト')
      # ログインボタンや新規登録ボタンは存在しない
      expect(page).to have_no_content('ログイン')
      expect(page).to have_no_content('新規登録')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # ログインページへ遷移していることを確認する
      expect(current_path).to eq(new_user_session_path)
      # 新規登録ボタンが存在する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit  new_user_registration_path
      # 誤ったユーザー情報を入力する
      fill_in 'ニックネーム', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード(確認用)', with: ''
      # 登録ボタンを押すとユーザーモデルのカウントは上がらない
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(0)
      # 新規登録ページへ戻される
      expect(current_path).to eq(user_registration_path)
    end
  end

    context 'ユーザーログインができるとき' do 
    it '正しい情報を入力すればログインできてトップページに移動する' do
      user = FactoryBot.create(:user)
      # トップページに移動する
      visit root_path
      # ログインページへ遷移していることを確認する
      expect(current_path).to eq(new_user_session_path)
      # ログインボタンが存在する
      expect(page).to have_content('ログイン')
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      # 登録ボタンをクリックする
      find('input[name="commit"]').click
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログアウトボタンが表示されている
      expect(page).to have_content('ログアウト')
      # ログインボタンや新規登録ボタンは存在しない
      expect(page).to have_no_content('ログイン')
      expect(page).to have_no_content('新規登録')
    end
  end
  context 'ログインができないとき' do
    it '誤った情報ではログインできずにログインページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # ログインページへ遷移していることを確認する
      expect(current_path).to eq(new_user_session_path)
      # ログインボタンが存在する
      expect(page).to have_content('ログイン')
      # 誤ったユーザー情報を入力する
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # 新規登録ページへ戻される
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
