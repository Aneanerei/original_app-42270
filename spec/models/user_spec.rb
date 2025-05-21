require 'rails_helper'

RSpec.describe User, type: :model do
  describe "関連付け" do
    it "expenses を持つ" do
      user = User.reflect_on_association(:expenses)
      expect(user.macro).to eq :has_many
    end

    it "category_expenses を持つ" do
      assoc = User.reflect_on_association(:category_expenses)
      expect(assoc.macro).to eq :has_many
    end

    it "incomes を持つ" do
      assoc = User.reflect_on_association(:incomes)
      expect(assoc.macro).to eq :has_many
    end

    it "category_incomes を持つ" do
      assoc = User.reflect_on_association(:category_incomes)
      expect(assoc.macro).to eq :has_many
    end

    it "work_times を持つ" do
      assoc = User.reflect_on_association(:work_times)
      expect(assoc.macro).to eq :has_many
    end

    it "category_work_times を持つ" do
      assoc = User.reflect_on_association(:category_work_times)
      expect(assoc.macro).to eq :has_many
    end

    it "monthly_goals を持つ" do
      assoc = User.reflect_on_association(:monthly_goals)
      expect(assoc.macro).to eq :has_many
    end
  end

  describe "dependent: :destroy の動作" do
    let!(:user) { FactoryBot.create(:user) }

    it "user 削除で income も削除される" do
      FactoryBot.create(:income, user: user)
      expect { user.destroy }.to change(Income, :count).by(-1)
    end

    it "user 削除で expense も削除される" do
      FactoryBot.create(:expense, user: user)
      expect { user.destroy }.to change(Expense, :count).by(-1)
    end
  end
end
