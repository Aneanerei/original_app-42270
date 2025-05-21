require 'rails_helper'

RSpec.describe WorkTime, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category_work_time, user: user) }

  describe "バリデーション" do
    it "有効なファクトリであれば有効" do
      work_time = FactoryBot.build(:work_time, user: user, category_work_time: category)
      expect(work_time).to be_valid
    end

    it "カテゴリが0なら無効" do
      work_time = FactoryBot.build(:work_time, user: user, category_work_time_id: 0)
      expect(work_time).not_to be_valid
      expect(work_time.errors[:category_work_time_id]).to include("を選択してください")
    end

    it "日付がなければ無効" do
      work_time = FactoryBot.build(:work_time, user: user, category_work_time: category, date: nil)
      expect(work_time).not_to be_valid
      expect(work_time.errors[:date]).to include("日付を入力してください。")
    end

    it "minutes がなければ無効" do
      work_time = FactoryBot.build(:work_time, user: user, category_work_time: category, minutes: nil)
      expect(work_time).not_to be_valid
      expect(work_time.errors[:minutes]).to include("労働時間を入力してください。")
    end

    it "minutes が0以下なら無効" do
      work_time = FactoryBot.build(:work_time, user: user, category_work_time: category, minutes: 0)
      expect(work_time).not_to be_valid
      expect(work_time.errors[:minutes]).to include("は1分以上の整数で入力してください。")
    end
  end

  describe "アソシエーション" do
    it "user に属している" do
      expect(WorkTime.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "category_work_time に属している（optional）" do
      assoc = WorkTime.reflect_on_association(:category_work_time)
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:optional]).to be true
    end
  end

  describe "インスタンスメソッド" do
    it "start_time が date を返す" do
      work_time = FactoryBot.build(:work_time, user: user, category_work_time: category, date: Date.today)
      expect(work_time.start_time).to eq(work_time.date)
    end
  end
end
