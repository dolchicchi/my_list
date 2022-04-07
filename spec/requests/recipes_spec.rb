require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @ingredient = FactoryBot.create(:ingredient, recipe_id: @recipe.id)
    @recipe_ingredient = FactoryBot.build(:recipe_ingredient, user_id: @user.id)
    @folder = FactoryBot.create(:folder,user_id: @user.id)
    sleep 0.1
  end

  describe 'GET #index' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get recipes_path
        expect(response.status).to eq 200
      end
      it 'レスポンスに登録済みのレシピのタイトルが存在する' do 
        get recipes_path
        expect(response.body).to include(@recipe.title)
      end
      it 'レスポンスに登録済みの参考URLが存在する' do 
        get recipes_path
        expect(response.body).to include(@recipe.source)
      end
      it 'レスポンスに登録済みのレシピの食材名が存在する' do 
        get recipes_path
        expect(response.body).to include(@recipe.ingredients[0].name)
      end
      it 'レスポンスに登録済みのレシピの食材の分量が存在する' do
        get recipes_path
        amount = @recipe.ingredients[0].amount.to_i
        expect(response.body).to include(amount.to_s) 
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get recipes_path
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #new' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it '正常にレスポンスが返ってくる' do 
        get new_recipe_path
        expect(response.status).to eq 200
      end
      it 'レスポンスにユーザーに紐づくフォルダのタイトルが存在する' do 
        get new_recipe_path
        expect(response.body).to include(@folder.title)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get new_recipe_path
        expect(response.status).to eq 302
      end
    end
  end

  describe 'GET #edit' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it '正常にレスポンスが返ってくる' do 
        get edit_recipe_path(@recipe)
        expect(response.status).to eq 200
      end
      it 'レスポンスにレシピのタイトルが存在する' do 
        get edit_recipe_path(@recipe)
        expect(response.body).to include(@recipe.title)
      end
      it 'レスポンスにレシピの参考URLが存在する' do 
        get edit_recipe_path(@recipe)
        expect(response.body).to include(@recipe.source)
      end
      it 'レスポンスにユーザーに紐づくフォルダが存在する' do 
        get edit_recipe_path(@recipe)
        expect(response.body).to include(@folder.title)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get edit_recipe_path(@recipe)
        expect(response.status).to eq 302
      end
    end
  end
end
