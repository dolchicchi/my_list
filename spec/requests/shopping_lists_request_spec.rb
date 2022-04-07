require 'rails_helper'

RSpec.describe "ShoppingLists", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @list = FactoryBot.create(:list, user_id: @user.id, recipe_id: @recipe.id)
    @ingredient = FactoryBot.create(:ingredient, recipe_id: @recipe.id)
    sleep 0.1
  end

  describe 'GET #index' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get shopping_lists_path
        expect(response.status).to eq 200
      end
      it 'レスポンスに食材名が存在する' do 
        get shopping_lists_path
        expect(response.body).to include(@ingredient.name)
      end
      it 'レスポンスに食材の分量が存在する' do 
        get shopping_lists_path
        expect(response.body).to include("#{@ingredient.amount.ceil}")
      end
      it 'レスポンスに単位が存在する' do 
        get shopping_lists_path
        expect(response.body).to include(@ingredient.unit.name)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get shopping_lists_path
        expect(response.status).to eq 302
      end
    end
  end
end
