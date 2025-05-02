class Income < ApplicationRecord
  belongs_to :user
  belongs_to :category_income

  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "金額は0以上の整数で入力してください" } 
  validates :date, presence: { message: "日付を入力してください。" }
  validates :category_income_id, presence: { message: "カテゴリを選択してください。" }

end
