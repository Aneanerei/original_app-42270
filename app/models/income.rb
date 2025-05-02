class Income < ApplicationRecord
  belongs_to :user
  belongs_to :category_income

  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "金額は0以上の整数で入力してください" } 
  validates :date, presence: { message: "日付を入力してください。" }
  validates :category_income_id, presence: { message: "カテゴリを選択してください。" }
  validates :labor_time, numericality: {
    greater_than_or_equal_to: 0,
    less_than: 1440,
    allow_nil: true,
    message: "は0分以上1440分未満で入力してください"
  }
  validate :daily_labor_time_within_limit

  def daily_labor_time_within_limit
  return if labor_time.nil? || date.nil?

  # 同じ日の他の収入の労働時間合計（自分自身を除外）
  total_labor_today = Income.where(user_id: user_id, date: date).where.not(id: id).sum(:labor_time)

  if total_labor_today + labor_time > 1440
    errors.add(:labor_time, "その日の合計労働時間が24時間（1440分）を超えています")
  end
 end
end
