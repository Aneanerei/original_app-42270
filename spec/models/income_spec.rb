require 'rails_helper'

RSpec.describe Income, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:category_income) { FactoryBot.create(:category_income, user: user) }

  describe "バリデーション" do
    it "有効なファクトリであれば有効" do
      income = FactoryBot.build(:income, user: user, category_income: category_income)
      expect(income.valid?).to be true
    end

    it "日付がなければ無効" do
      income = FactoryBot.build(:income, user: user, category_income: category_income, date: nil)
      expect(income.valid?).to be false
      expect(income.errors[:date]).to include("日付を入力してください。")
    end

    it "カテゴリがなければ無効" do
      income = FactoryBot.build(:income, user: user, category_income: nil)
      expect(income.valid?).to be false
      expect(income.errors[:category_income_id]).to include("を選択してください。")
    end

    it "金額がnilだと無効" do
      income = FactoryBot.build(:income, user: user, category_income: category_income, amount: nil)
      expect(income.valid?).to be false
      expect(income.errors[:amount]).to include("は0円以上かつ2,147,483,647円以下で入力してください")
    end

    it "金額がマイナスだと無効" do
      income = FactoryBot.build(:income, user: user, category_income: category_income, amount: -1)
      expect(income.valid?).to be false
    end

    it "金額が2,147,483,648円だと無効" do
      income = FactoryBot.build(:income, user: user, category_income: category_income, amount: 2_147_483_648)
      expect(income.valid?).to be false
    end

    it "金額が0円なら有効" do
      income = FactoryBot.build(:income, user: user, category_income: category_income, amount: 0)
      expect(income.valid?).to be true
    end

    it "金額が小数だと無効" do
      income = FactoryBot.build(:income, user: user, category_income: category_income, amount: 123.45)
      expect(income.valid?).to be false
    end
  end

  describe "関連付け" do
    it "userと関連付いていること" do
      income = FactoryBot.build(:income)
      expect(income.user).to be_present
    end

    it "category_incomeと関連付いていること" do
      income = FactoryBot.build(:income)
      expect(income.category_income).to be_present
    end
  end
end
