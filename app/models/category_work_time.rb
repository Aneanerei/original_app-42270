class CategoryWorkTime < ApplicationRecord
 
    DEFAULT_CATEGORY_NAMES = %w[本業 副業 日雇い] 
  
    belongs_to :user, optional: true
    has_many :work_times
  
    validates :name, presence: true, uniqueness: { scope: :user_id }
  
    before_destroy :prevent_deletion_of_default_categories
  
    def default_category?
      user_id.nil? && DEFAULT_CATEGORY_NAMES.include?(name)
    end
  

    private

    def category_limit
      return if user_id.nil?  # 共通カテゴリは対象外
  
      if CategoryWorkTime.where(user_id: user_id).count >= 5
        errors.add(:base, "カテゴリの追加は最大5つまでです")
      end
    end
  
    def prevent_deletion_of_default_categories
      if default_category?
        errors.add(:base, "初期カテゴリは削除できません")
        throw(:abort)
      end
    end
  end