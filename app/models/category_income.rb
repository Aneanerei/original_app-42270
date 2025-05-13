class CategoryIncome < ApplicationRecord
  DEFAULT_CATEGORY_NAMES = %w[給料 副収入 臨時収入].freeze

  belongs_to :user, optional: true
  has_many :incomes
  has_many :work_times  # 労働時間がこのカテゴリを参照する場合に必要

  before_destroy :prevent_deletion_of_default_categories
  validates :name,
    presence: { message: "を入力してください" },
    uniqueness: { scope: :user_id, message: "はすでに存在しています" },
    length: { maximum: 20 }
  validate :category_limit, on: :create

  
  private

  def prevent_deletion_of_default_categories
    if user_id.nil? && DEFAULT_CATEGORY_NAMES.include?(name)
      errors.add(:base, "初期カテゴリは削除できません")
      throw :abort
    end
  end

  def category_limit
    return if user_id.nil? # 共通カテゴリは制限対象外
    if user.category_incomes.where.not(name: DEFAULT_CATEGORY_NAMES).count >= 5
      errors.add(:base, "カテゴリの追加は最大5件までです")
    end
  end

end
