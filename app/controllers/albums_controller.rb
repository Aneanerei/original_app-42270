class AlbumsController < ApplicationController
  def index
    # current_user かつ画像付きの TaggedImage ID を取得
    taggable_ids = TaggedImage
      .joins(:expense)
      .where(expenses: { user_id: current_user.id })
      .with_attached_image
      .pluck(:id)

    # 使用中のタグのみ取得（頻度順）
    @tags = ActsAsTaggableOn::Tag
      .joins(:taggings)
      .where(taggings: {
        taggable_type: 'TaggedImage',
        taggable_id: taggable_ids
      })
      .group('tags.id')
      .select('tags.*, COUNT(taggings.id) as count')
      .order('count DESC')
    
    @my_tags = TaggedImage
      .joins(:expense)
      .where(expenses: { user_id: current_user.id })
      .tag_counts_on(:tags)
      .sort_by { |tag| -tag.count }
    
      # 人気順で表示
    @popular_tags = @tags.first(10)
    
    # 画像取得（current_userの画像付き）
    images = TaggedImage
      .joins(:expense)
      .where(expenses: { user_id: current_user.id })
      .with_attached_image
      .includes(:tags, :expense)
      .order(created_at: :desc)
      .select { |img| img.image.attached? }

    # タグ絞り込み
    if params[:tag].present? && params[:tag] != "すべて"
      images = images.select { |img| img.tag_list.include?(params[:tag]) }

    # キーワード検索（AND/OR）
    elsif params[:search].present?
      query = params[:search].strip

      if query.include?(",")
        words = query.split(/[,、]/).map(&:strip)
        images = images.select do |img|
          words.any? { |word| img.tag_list.any? { |tag| tag.include?(word) } }
        end
      else
        words = query.split(/[\s　]+/)
        images = images.select do |img|
          words.all? { |word| img.tag_list.any? { |tag| tag.include?(word) } }
        end
      end
    end

    @tagged_images = Kaminari.paginate_array(images).page(params[:page]).per(10)
  end
end