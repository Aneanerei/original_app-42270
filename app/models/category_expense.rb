class CategoryExpense < ApplicationRecord
  DEFAULT_CATEGORY_NAMES = %w[
    食費 外食費 交通費 衣服 交際費 通信費
    日用品 税金 医療費 保険 光熱費 住居費 趣味
  ].freeze

  MAX_CATEGORIES_PER_USER = 10

  belongs_to :user, optional: true
  has_many :expenses, dependent: :restrict_with_error

  validates :name,
    presence: { message: "を入力してください" },
    uniqueness: { scope: :user_id, message: "はすでに存在しています" },
    length: { maximum: 20 }

  validate :user_category_limit, on: :create

  before_destroy :prevent_deletion_of_default_categories

  private

  def prevent_deletion_of_default_categories
    if user_id.nil? && DEFAULT_CATEGORY_NAMES.include?(name)
      errors.add(:base, "デフォルトカテゴリは削除できません")
      throw :abort
    end
  end

  def user_category_limit
    return if user_id.nil? # 共通カテゴリは対象外

    if user.category_expenses.where.not(name: DEFAULT_CATEGORY_NAMES).count >= MAX_CATEGORIES_PER_USER
      errors.add(:base, "カテゴリの追加は最大#{MAX_CATEGORIES_PER_USER}件までです")
    end
  end
end
