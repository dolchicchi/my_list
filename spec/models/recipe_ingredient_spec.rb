require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  describe 'レシピ情報の保存' do
    before do
      user = FactoryBot.create(:user)
      @recipe_ingredient = FactoryBot.build(:recipe_ingredient, user_id: user.id)
      sleep 0.1
    end

    context '内容に問題ない場合' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(@recipe_ingredient).to be_valid
      end
      it '参考URLが空でも保存できること' do
        @recipe_ingredient.source = nil
        expect(@recipe_ingredient).to be_valid
      end
      it '食材名が空でもレシピ情報は保存できること' do
        @recipe_ingredient.name = nil
        expect(@recipe_ingredient).to be_valid
      end
      it '分量が空でもレシピ情報は保存できること' do
        @recipe_ingredient.amount = nil
        expect(@recipe_ingredient).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'レシピ名が空だと保存できないこと' do
        @recipe_ingredient.title = nil
        @recipe_ingredient.valid?
        expect(@recipe_ingredient.errors.full_messages).to include("Title can't be blank")
      end
    end
  end
end
