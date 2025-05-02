  class CategoryIncome < ApplicationRecord
    belongs_to :user
    has_many :incomes

    validates :name, presence: true, uniqueness: { scope: :user_id }
  
    validate :category_limit, on: :create
  
    private
  
    def category_limit
      if user.category_incomes.count >= 8
        errors.add(:base, "カテゴリの追加は最大5つまでです")
      end
    end
  end
