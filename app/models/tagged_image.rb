class TaggedImage < ApplicationRecord
  belongs_to :expense
  has_one_attached :image

  acts_as_taggable_on :tags

  delegate :memo, :date, :category_expense, to: :expense

  attr_accessor :removed_auto_tags

  # 画像が未添付の場合、タグを保存させない
  before_save :clear_tag_list_unless_image_attached, unless: :marked_for_destruction?

  # バリデーション：削除対象でないときにのみ実行
  validate :tag_list_requires_image, unless: :marked_for_destruction?

  private

  # 画像が未添付なら、タグをすべてクリアする（保存させない）
  def clear_tag_list_unless_image_attached
    self.tag_list = nil if tag_list.present? && !image.attached?
  end

  # タグがあるのに画像がない場合はエラー（ただし空白タグは無視）
  def tag_list_requires_image
    if tag_list.reject(&:blank?).any? && !image.attached?
      errors.add(:base, "タグは画像がある場合に入力してください")
    end
  end

end
