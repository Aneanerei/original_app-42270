class TaggedImage < ApplicationRecord
  belongs_to :expense
  has_one_attached :image

  acts_as_taggable_on :tags

  delegate :memo, :date, :category_expense, to: :expense

  attr_accessor :removed_auto_tags

  before_validation :clear_tag_list_unless_image_attached, unless: :marked_for_destruction?
  
  validate :image_or_tag_required, unless: :marked_for_destruction?
  validate :tag_list_requires_image, unless: :marked_for_destruction?


  private

  # 画像が未添付ならタグをクリア（保存されないように）
  def clear_tag_list_unless_image_attached
    self.tag_list = nil if tag_list.present? && !image.attached?
  end

  # タグがある場合は画像も必須（ただしimageが未添付ならエラー）
  def tag_list_requires_image
    if tag_list.present? && !image.attached?
      errors.add(:base, "タグは画像がある場合に入力してください")
    end
  end

  # 画像もタグもなければエラー（両方空は不可）
  def image_or_tag_required
    if image.blank? && tag_list.blank?
      errors.add(:base, "画像またはタグのいずれかを入力してください")
    end
  end
end
