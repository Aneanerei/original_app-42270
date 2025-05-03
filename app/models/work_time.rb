class WorkTime < ApplicationRecord
  belongs_to :user
  belongs_to :category_income

  validates :category_income_id, presence: { message: "カテゴリを選択してください。" }
  validates :date, presence: { message: "日付を入力してください" }
  validates :minutes, presence: { message: "労働時間を入力してください" }
  validates :minutes, numericality: {
    only_integer: true,
    greater_than: 0,
    message: "は1分以上の整数で入力してください"
  }
end
