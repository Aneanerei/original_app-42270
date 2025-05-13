class MonthlyGoal < ApplicationRecord
  belongs_to :user

  validates :year, :month, presence: true
  validates :income_goal, :savings_goal, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :month, inclusion: 1..12
  validates :year, numericality: { greater_than: 2000 }

  validates :user_id, uniqueness: { scope: [:year, :month], message: "はすでにこの月の目標を設定済みです" }
end

