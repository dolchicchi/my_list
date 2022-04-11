require 'rails_helper'

RSpec.describe List, type: :model do
  before do
    @list = FactoryBot.build(:list)
    sleep 0.1
  end

  describe 'リスト新規作成' do
    context '新規作成できる場合' do
      it "全ての項目が正しく入力されていれば登録できる" do
        expect(@list).to be_valid
      end
    end
    
    context '新規作成できない場合' do
      it "dateが空では登録できない" do
        @list.date = nil
        @list.valid?
        expect(@list.errors.full_messages).to include("Date can't be blank")
      end
      it "紐づくユーザーが存在しないと登録できない" do
        @list.user = nil
        @list.valid?
        expect(@list.errors.full_messages).to include("User must exist")
      end
      it "紐づくレシピが存在しないと登録できない" do
        @list.recipe = nil
        @list.valid?
        expect(@list.errors.full_messages).to include("Recipe must exist")
      end
    end
  end
end
