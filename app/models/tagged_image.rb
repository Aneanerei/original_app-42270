class TaggedImage < ApplicationRecord
  belongs_to :expense
  has_one_attached :image
  acts_as_taggable_on :tags

  before_validation :clear_tag_list_unless_image_attached

  validate :tag_list_requires_image
  
  private
  
  def clear_tag_list_unless_image_attached
    self.tag_list = nil unless image.attached?
  end
  
  def tag_list_requires_image
    if tag_list.present? && !image.attached?
      errors.add(:tag_list, "は画像がある場合に入力してください")
    end
  end
  

end