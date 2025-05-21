require 'rails_helper'

RSpec.describe CategoryWorkTime, type: :model do
  let(:user) { create(:user) }

  context "バリデーション" do
    it "有効な名前とユーザーがあれば有効" do
      category = CategoryWorkTime.new(name: "アルバイト", user: user)
      expect(category).to be_valid
    end

    it "名前がなければ無効" do
      category = CategoryWorkTime.new(name: nil, user: user)
      expect(category).to be_invalid
      expect(category.errors[:name]).to include("を入力してください")
    end

    it "名前が20文字を超えると無効" do
      category = CategoryWorkTime.new(name: "あ" * 21, user: user)
      expect(category).to be_invalid
    end

    it "同一ユーザーに同じ名前のカテゴリは作れない" do
      create(:category_work_time, name: "副業", user: user)
      duplicate = CategoryWorkTime.new(name: "副業", user: user)
      expect(duplicate).to be_invalid
      expect(duplicate.errors[:name]).to include("はすでに存在しています")
    end

    it "他のユーザーの同名カテゴリは許可される" do
      other_user = create(:user)
      create(:category_work_time, name: "副業", user: other_user)
      category = CategoryWorkTime.new(name: "副業", user: user)
      expect(category).to be_valid
    end
  end

  context "カテゴリ上限" do
    it "ユーザーごとのカテゴリは5件まで" do
      5.times do |i|
        create(:category_work_time, name: "カテゴリ#{i}", user: user)
      end
      sixth = CategoryWorkTime.new(name: "カテゴリ6", user: user)
      expect(sixth).to be_invalid
      expect(sixth.errors[:base]).to include("カテゴリの追加は最大5つまでです")
    end

    it "共通カテゴリ（user_idなし）は上限対象外" do
      10.times do |i|
        create(:category_work_time, name: "共通#{i}", user: nil)
      end
      category = CategoryWorkTime.new(name: "追加カテゴリ", user: nil)
      expect(category).to be_valid
    end
  end

  context "初期カテゴリの削除制限" do
    it "初期カテゴリは削除できない" do
      category = create(:category_work_time, name: "本業", user: nil)
      expect(category.destroy).to be false
      expect(category.errors[:base]).to include("初期カテゴリは削除できません")
    end

    it "ユーザー固有のカテゴリは削除できる" do
      category = create(:category_work_time, name: "バイト", user: user)
      expect { category.destroy }.to change { CategoryWorkTime.count }.by(-1)
    end
  end
end
