require 'rails_helper'

RSpec.describe Folder, type: :model do
  before do
    @folder = FactoryBot.build(:folder)
    sleep 0.02
  end

  describe 'フォルダ新規作成' do
    context '新規作成できる場合' do
      it "全ての項目が正しく入力されていれば登録できる" do
        expect(@folder).to be_valid
      end
    end
    
    context '新規作成できない場合' do
      it "titleが空では登録できない" do
        @folder.title = nil
        @folder.valid?
        expect(@folder.errors.full_messages).to include("Title can't be blank")
      end
      it "紐づくユーザーが存在しないと登録できない" do
        @folder.user = nil
        @folder.valid?
        expect(@folder.errors.full_messages).to include("User must exist")
      end
    end
  end
end
