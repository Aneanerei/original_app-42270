class TaggedImage < ApplicationRecord
  belongs_to :expense
  has_one_attached :image
  acts_as_taggable_on :tags
  validate :image_presence_if_tag_exists

private

def image_presence_if_tag_exists
  if tag_list.present? && !image.attached?
    errors.add(:image, "が選択されていません（タグを付けるには画像が必要です）")
  end
end
end