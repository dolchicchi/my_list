require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe '食材の追加登録' do
    before do
      user = FactoryBot.create(:user)
      recipe = FactoryBot.create(:recipe, user_id: user.id)
      @ingredient = FactoryBot.build(:ingredient, recipe_id: recipe.id)
      sleep 0.02
    end

    context '内容に問題ない場合' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(@ingredient).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it '食材名が空だと保存できないこと' do
        @ingredient.name = nil
        @ingredient.valid?
        expect(@ingredient.errors.full_messages).to include("Name can't be blank")
      end
      it '分量が空だと保存できないこと' do
        @ingredient.amount = nil
        @ingredient.valid?
        expect(@ingredient.errors.full_messages).to include("Amount can't be blank")
      end
      it '分量に文字が含まれていると保存できないこと' do
        @ingredient.amount = Faker::Lorem.characters(number: 3, min_alpha: 1, min_numeric: 1)
        @ingredient.valid?
        expect(@ingredient.errors.full_messages).to include('Amount is not a number')
      end
      it 'unit_idが1だと保存できないこと' do
        @ingredient.unit_id = 1
        @ingredient.valid?
        expect(@ingredient.errors.full_messages).to include('Unit must be other than 1')
      end
    end
  end
end
