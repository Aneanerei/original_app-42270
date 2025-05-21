require 'rails_helper'

RSpec.describe MonthlyGoal, type: :model do
  let(:user) { create(:user) }

  describe "バリデーション" do
    it "有効なデータで保存できる" do
      goal = build(:monthly_goal, user: user, year: 2025, month: 5, income_goal: 100_000, savings_goal: 50_000)
      expect(goal).to be_valid
    end

    it "年と月がなければ無効" do
      goal = build(:monthly_goal, user: user, year: nil, month: nil)
      expect(goal).to be_invalid
      expect(goal.errors[:year]).to be_present
      expect(goal.errors[:month]).to be_present
    end

    it "月は1〜12の範囲外だと無効" do
      invalid_goal = build(:monthly_goal, user: user, month: 13)
      expect(invalid_goal).to be_invalid
      expect(invalid_goal.errors[:month]).to include("は一覧にありません")
    end

    it "年が2000以下だと無効" do
      goal = build(:monthly_goal, user: user, year: 1999)
      expect(goal).to be_invalid
    end

    it "収入・貯金目標が負の数だと無効" do
      goal = build(:monthly_goal, user: user, income_goal: -100, savings_goal: -500)
      expect(goal).to be_invalid
      expect(goal.errors[:income_goal]).to include("は0以上の値にしてください")
      expect(goal.errors[:savings_goal]).to include("は0以上の値にしてください")
    end

    it "収入・貯金目標はnilでも保存可能" do
      goal = build(:monthly_goal, user: user, income_goal: nil, savings_goal: nil)
      expect(goal).to be_valid
    end

    it "同じユーザー・年・月の組み合わせは一意でなければならない" do
      create(:monthly_goal, user: user, year: 2025, month: 5)
      duplicate = build(:monthly_goal, user: user, year: 2025, month: 5)
      expect(duplicate).to be_invalid
      expect(duplicate.errors[:user_id]).to include("はすでにこの月の目標を設定済みです")
    end

    it "別ユーザーなら同じ年月でも保存できる" do
      other_user = create(:user)
      create(:monthly_goal, user: user, year: 2025, month: 5)
      goal = build(:monthly_goal, user: other_user, year: 2025, month: 5)
      expect(goal).to be_valid
    end
  end
end
