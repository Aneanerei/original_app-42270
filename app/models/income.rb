class Income < ApplicationRecord
  belongs_to :user
  belongs_to :category_income

  validates :amount, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    message: "は0円以上で入力してください。"
  }
  validates :amount, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 2_147_483_647,
    message: "は2,147,483,647円以下にしてください"
  }
  validates :date, presence: { message: "日付を入力してください。" }
  validates :category_income_id, presence: { message: "を選択してください。" }
end
