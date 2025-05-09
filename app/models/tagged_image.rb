class TaggedImage < ApplicationRecord
  belongs_to :expense
  has_one_attached :image
  acts_as_taggable_on :tags
  validate :image_presence_if_tag_exists

private
def image_presence_if_tag_exists
  if tag_list.present? && !image.attached?
    errors.add(:tags, "は画像がある場合に入力してください")
  end
end
end