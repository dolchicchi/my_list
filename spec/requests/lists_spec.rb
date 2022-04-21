require 'rails_helper'

RSpec.describe "Lists", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.create(:recipe, user_id: @user.id)
    @list = FactoryBot.create(:list, user_id: @user.id, recipe_id: @recipe.id)
    sleep 0.02
  end

  describe 'GET #index' do
    context "ログインしている場合" do
      before do
        sign_in @user
      end
      it 'リクエストすると正常にレスポンスが返ってくる' do 
        get lists_path
        expect(response.status).to eq 200
      end
      it 'レスポンスに登録済みのレシピのタイトルが存在する' do 
        get lists_path
        expect(response.body).to include(@recipe.title)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get lists_path
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
        get new_list_path
        expect(response.status).to eq 200
      end
      it 'レスポンスに登録済みのフォルダのタイトルが存在する' do 
        get new_list_path
        expect(response.body).to include(@recipe.title)
      end
    end
    context "ログインしていない場合" do
      it '別のアクションへ遷移される' do 
        get lists_path
        expect(response.status).to eq 302
      end
    end
  end
end
