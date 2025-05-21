class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category_expense

  has_many :tagged_images, inverse_of: :expense, dependent: :destroy
  accepts_nested_attributes_for :tagged_images, allow_destroy: true

  validates :date, presence: { message: "を入力してください" }

  validates :amount,
    presence: { message: "を入力してください" },
    numericality: { greater_than_or_equal_to: 0, message: "は0円以上で入力してください" }

  validates :category_expense_id, presence: { message: "を選択してください" }
  validates :memo, length: { maximum: 300 }

  def tag_array
    tag_list.to_s.split(",").map(&:strip)
  end
end
