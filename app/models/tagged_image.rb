class TaggedImage < ApplicationRecord
  belongs_to :expense
  has_one_attached :image

  acts_as_taggable_on :tags

  delegate :memo, :date, :category_expense, to: :expense

  attr_accessor :removed_auto_tags

  before_save :clear_tag_list_unless_image_attached, unless: :marked_for_destruction?

  validate :presence_of_image_or_tag_list, unless: :marked_for_destruction?
  validate :tag_list_requires_image, unless: :marked_for_destruction?

  private

  def clear_tag_list_unless_image_attached
    self.tag_list = nil if tag_list.present? && !image.attached?
  end

  def tag_list_requires_image
    if tag_list.reject(&:blank?).any? && !image.attached?
      errors.add(:base, "タグは画像がある場合に入力してください")
    end
  end

  def presence_of_image_or_tag_list
    if tag_list.blank? && !image.attached?
      errors.add(:base, "画像またはタグのいずれかを入力してください")
    end
  end
end
