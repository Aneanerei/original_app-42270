class WorkTime < ApplicationRecord
  belongs_to :user

  validates :date, presence: { message: "日付を入力してください" }
  validates :minutes, presence: { message: "労働時間を入力してください" }
  validates :minutes, numericality: {
    only_integer: true,
    greater_than: 0,
    message: "は1分以上の整数で入力してください"
  }
end
