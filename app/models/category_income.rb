  class CategoryIncome < ApplicationRecord
    belongs_to :user
    has_many :incomes
    has_many :work_times
    before_destroy :prevent_deletion_of_default_categories

    validates :name, presence: true, uniqueness: { scope: :user_id }
    validate :category_limit, on: :create
  
    private
  
    def category_limit
      if user.category_incomes.count >= 8
        errors.add(:base, "カテゴリの追加は最大5つまでです")
      end
    end
    def prevent_deletion_of_default_categories
      if DEFAULT_CATEGORY_NAMES.include?(name)
         errors.add(:base, "初期カテゴリは削除できません")
         throw(:abort)  # 削除をキャンセル
      end
    end
    end
  