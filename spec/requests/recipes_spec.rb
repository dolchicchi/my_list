require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @ingredient = FactoryBot.create(:ingredient, recipe_id: @recipe.id)
    sleep 0.1
  end

  describe 'GET #index' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do 
        get recipes_path
        expect(response.status).to eq 200
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みのレシピのタイトルが存在する' do 
        get recipes_path
        expect(response.body).to include(@recipe.title)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みの参考URLが存在する' do 
        get recipes_path
        expect(response.body).to include(@recipe.source)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みのレシピの食材名が存在する' do 
        get recipes_path
        expect(response.body).to include(@recipe.ingredients[0].name)
      end
      it 'indexアクションにリクエストするとレスポンスに登録済みのレシピの食材の分量が存在する' do
        get recipes_path
        amount = @recipe.ingredients[0].amount.to_i
        expect(response.body).to include(amount.to_s) 
      end
      it 'indexアクションにリクエストするとレスポンスに検索フォームが存在する' do
        get recipes_path
        expect(response.body).to include('レシピ名か食材名を入力して下さい') 
      end
    end

    context "ログインしていない場合" do
      it 'indexアクションにリクエストすると別のアクションへ遷移される' do 
        get recipes_path
        expect(response.status).to eq 302
      end
    end
  end
end
