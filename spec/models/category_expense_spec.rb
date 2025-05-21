require 'rails_helper'

RSpec.describe CategoryExpense, type: :model do
  let(:user) { create(:user) }

  describe "バリデーション" do
    it "有効な名前とユーザーがあれば有効" do
      category = build(:category_expense, name: "ペット費", user: user)
      expect(category).to be_valid
    end

    it "名前がないと無効" do
      category = build(:category_expense, name: nil, user: user)
      expect(category).to be_invalid
      expect(category.errors[:name]).to include("を入力してください")
    end

    it "名前が20文字を超えると無効" do
      category = build(:category_expense, name: "あ" * 21, user: user)
      expect(category).to be_invalid
    end

    it "同一ユーザーに同じ名前のカテゴリは作れない" do
      create(:category_expense, name: "交通費", user: user)
      duplicate = build(:category_expense, name: "交通費", user: user)
      expect(duplicate).to be_invalid
      expect(duplicate.errors[:name]).to include("はすでに存在しています")
    end

    it "別ユーザーの同名カテゴリは有効" do
      other_user = create(:user)
      create(:category_expense, name: "交際費", user: other_user)
      category = build(:category_expense, name: "交際費", user: user)
      expect(category).to be_valid
    end
  end

  describe "カテゴリ数制限" do
    it "ユーザーはデフォルトカテゴリを除いて最大10件までしか追加できない" do
      CategoryExpense::DEFAULT_CATEGORY_NAMES.each do |name|
        create(:category_expense, name: name, user: user)
      end

      10.times do |i|
        create(:category_expense, name: "自由カテゴリ#{i}", user: user)
      end

      extra = build(:category_expense, name: "超過カテゴリ", user: user)
      expect(extra).to be_invalid
      expect(extra.errors[:base]).to include("カテゴリの追加は最大10件までです")
    end

    it "共通カテゴリ（user_idなし）は制限対象外" do
      15.times do |i|
        create(:category_expense, name: "共通カテゴリ#{i}", user: nil)
      end

      expect(build(:category_expense, name: "さらに共通", user: nil)).to be_valid
    end
  end

  describe "削除制限" do
    it "デフォルトカテゴリ（共通）を削除しようとすると失敗する" do
      category = create(:category_expense, name: "食費", user: nil)
      expect(category.destroy).to be false
      expect(category.errors[:base]).to include("デフォルトカテゴリは削除できません")
    end

    it "ユーザー作成カテゴリは削除できる" do
      category = create(:category_expense, name: "ギフト", user: user)
      expect { category.destroy }.to change(CategoryExpense, :count).by(-1)
    end
  end

  describe "関連支出がある場合の削除制限" do
    it "関連する支出がある場合、削除できない" do
      category = create(:category_expense, user: user)
      create(:expense, user: user, category_expense: category)

      expect(category.destroy).to be false
      expect(category.errors[:base]).to include("expensesが存在しているので削除できません")
    end

  end
end
