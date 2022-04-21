require 'rails_helper'

RSpec.describe "Ingredients", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @ingredient = FactoryBot.create(:ingredient, recipe_id: @recipe.id)
    sleep 0.02
  end

  describe 'GET #new' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get new_recipe_ingredient_path(@recipe)
        expect(response.status).to eq 200
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get new_recipe_ingredient_path(@recipe)
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
        get edit_recipe_ingredient_path(@recipe, @ingredient)
        expect(response.status).to eq 200
      end
      it 'レスポンスに食材の名前が含まれて返ってくる' do 
        get edit_recipe_ingredient_path(@recipe, @ingredient)
        expect(response.body).to include(@ingredient.name)
      end
      it 'レスポンスに食材の分量が含まれて返ってくる' do 
        get edit_recipe_ingredient_path(@recipe, @ingredient)
        expect(response.body).to include(@ingredient.amount.to_s)
      end
      it 'レスポンスに材料の単位が含まれて返ってくる' do 
        get edit_recipe_ingredient_path(@recipe, @ingredient)
        expect(response.body).to include(@ingredient.unit.name)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get edit_recipe_ingredient_path(@recipe, @ingredient)
        expect(response.status).to eq 302
      end
    end
  end
end
