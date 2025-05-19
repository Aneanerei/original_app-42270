class WorkTime < ApplicationRecord
  belongs_to :user
  belongs_to :category_work_time, optional: true
  validates :category_work_time_id, numericality: { other_than: 0, message: "を選択してください" }
  validates :date, presence: { message: "日付を入力してください。" }
  validates :minutes, presence: { message: "労働時間を入力してください。" }
  validates :minutes, numericality: {
    only_integer: true,
    greater_than: 0,
    message: "は1分以上の整数で入力してください。"
  }
    def start_time
    date
  end
end
