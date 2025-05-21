require 'rails_helper'

RSpec.describe CategoryIncome, type: :model do
  let(:user) { create(:user) }

  describe "バリデーション" do
    it "有効な名前とユーザーがあれば有効" do
      category = build(:category_income, name: "ボーナス", user: user)
      expect(category).to be_valid
    end

    it "名前がないと無効" do
      category = build(:category_income, name: nil, user: user)
      expect(category).to be_invalid
      expect(category.errors[:name]).to include("を入力してください")
    end

    it "名前が20文字を超えると無効" do
      category = build(:category_income, name: "あ" * 21, user: user)
      expect(category).to be_invalid
    end

    it "同一ユーザーに同じ名前のカテゴリは作れない" do
      create(:category_income, name: "副収入", user: user)
      duplicate = build(:category_income, name: "副収入", user: user)
      expect(duplicate).to be_invalid
      expect(duplicate.errors[:name]).to include("はすでに存在しています")
    end

    it "別ユーザーの同名カテゴリは許可される" do
      other_user = create(:user)
      create(:category_income, name: "副収入", user: other_user)
      category = build(:category_income, name: "副収入", user: user)
      expect(category).to be_valid
    end
  end

  describe "カテゴリ数制限" do
    it "デフォルトカテゴリを除いて5件までしか作成できない" do
      CategoryIncome::DEFAULT_CATEGORY_NAMES.each do |name|
        create(:category_income, name: name, user: user)
      end

      5.times do |i|
        create(:category_income, name: "自由#{i}", user: user)
      end

      extra = build(:category_income, name: "追加カテゴリ", user: user)
      expect(extra).to be_invalid
      expect(extra.errors[:base]).to include("カテゴリの追加は最大5件までです")
    end

    it "共通カテゴリ（user_id=nil）は制限を受けない" do
      10.times do |i|
        create(:category_income, name: "共通#{i}", user: nil)
      end
      expect(build(:category_income, name: "さらに共通", user: nil)).to be_valid
    end
  end

  describe "初期カテゴリの削除制限" do
    it "初期カテゴリ（user_idがnil）で該当名のものは削除できない" do
      category = create(:category_income, name: "給料", user: nil)
      expect(category.destroy).to be false
      expect(category.errors[:base]).to include("初期カテゴリは削除できません")
    end

    it "ユーザー固有カテゴリは削除できる" do
      category = create(:category_income, name: "講演料", user: user)
      expect { category.destroy }.to change(CategoryIncome, :count).by(-1)
    end
  end
end
