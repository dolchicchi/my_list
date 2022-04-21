require 'rails_helper'

RSpec.describe "Folders", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @folder = FactoryBot.create(:folder,user_id: @user.id)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id, folder_id: @folder.id)
    sleep 0.02
  end

  describe 'GET #index' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get folders_path
        expect(response.status).to eq 200
      end
      it 'レスポンスに登録済みのフォルダのタイトルが存在する' do 
        get folders_path
        expect(response.body).to include(@folder.title)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get folders_path
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #new' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get new_folder_path
        expect(response.status).to eq 200
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get new_folder_path
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #show' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get folder_path(@folder)
        expect(response.status).to  eq 200
      end
      it 'レスポンスにフォルダのタイトルが存在する' do 
        get folder_path(@folder)
        expect(response.body).to include(@folder.title)
      end
      it 'レスポンスに紐づくレシピのタイトルが存在する' do 
        get folder_path(@folder)
        expect(response.body).to include(@recipe.title)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        post folders_path
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #edit' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get edit_folder_path(@folder)
        expect(response.status).to eq 200
      end
      it 'レスポンスにフォルダのタイトルが存在する' do 
        get edit_folder_path(@folder)
        expect(response.body).to include(@folder.title)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get edit_folder_path(@folder)
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #add_recipe_select' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get add_recipe_select_folder_path(@folder)
        expect(response.status).to eq 200
      end
      it 'レスポンスに未登録のレシピのタイトルが存在する' do 
        recipe = FactoryBot.create(:recipe, user_id: @user.id)
        get add_recipe_select_folder_path(@folder)
        expect(response.body).to include(recipe.title)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get add_recipe_select_folder_path(@folder)
        expect(response.status).to eq 302
      end
    end
  end
end
