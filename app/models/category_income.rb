  class CategoryIncome < ApplicationRecord
    belongs_to :user
    validates :name, presence: true, uniqueness: { scope: :user_id }
  
    validate :category_limit, on: :create
  
    private
  
    def category_limit
      if user.category_incomes.count >= 5
        errors.add(:base, "カテゴリは最大5つまでです")
      end
    end
  end
