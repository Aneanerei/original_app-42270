require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category_expense, user: user) }

  describe "バリデーション" do
    it "有効なファクトリであれば有効" do
      expense = FactoryBot.build(:expense, user: user, category_expense: category)
      expect(expense).to be_valid
    end

    it "日付がなければ無効" do
      expense = FactoryBot.build(:expense, user: user, category_expense: category, date: nil)
      expect(expense).not_to be_valid
    end

    it "金額がマイナスなら無効" do
      expense = FactoryBot.build(:expense, user: user, category_expense: category, amount: -1)
      expect(expense).not_to be_valid
    end

    it "カテゴリがなければ無効" do
      expense = FactoryBot.build(:expense, user: user, category_expense: nil)
      expect(expense).not_to be_valid
    end

    it "メモが300文字以内なら有効" do
      memo = "あ" * 300
      expense = FactoryBot.build(:expense, user: user, category_expense: category, memo: memo)
      expect(expense).to be_valid
    end

    it "メモが301文字以上なら無効" do
      memo = "あ" * 301
      expense = FactoryBot.build(:expense, user: user, category_expense: category, memo: memo)
      expect(expense).not_to be_valid
    end
  end

  describe "アソシエーション" do
    it "tagged_imagesを複数持てる" do
      expense = FactoryBot.create(:expense, user: user, category_expense: category)
      tagged_image = FactoryBot.create(:tagged_image, expense: expense)
      expect(expense.tagged_images).to include(tagged_image)
    end
  end
end
