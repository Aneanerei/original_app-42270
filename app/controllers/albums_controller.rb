class AlbumsController < ApplicationController
  def index
    @tags = TaggedImage.tag_counts_on(:tags)

    # 画像あり・current_user のみに絞り込み
    images = TaggedImage
      .joins(:expense)
      .where(expenses: { user_id: current_user.id })
      .with_attached_image
      .select { |img| img.image.attached? }
      .sort_by(&:created_at).reverse

    # タグ絞り込み（URLで指定されたタグ）
    if params[:tag].present? && params[:tag] != "すべて"
      images = images.select { |img| img.tag_list.include?(params[:tag]) }

    # 検索キーワードからのタグ検索（フォーム）
 elsif params[:search].present?
  query = params[:search].strip

  if query.include?(",") # OR検索（カンマ区切り）
    words = query.split(/[,、]/).map(&:strip)
    images = images.select do |img|
      words.any? { |word| img.tag_list.any? { |tag| tag.include?(word) } }
    end
  else # AND検索（全角/半角スペース含めて）
    words = query.split(/[\s　]+/)
    images = images.select do |img|
      words.all? { |word| img.tag_list.any? { |tag| tag.include?(word) } }
    end
  end

    end

    @tagged_images = Kaminari.paginate_array(images).page(params[:page]).per(10)
  end
end