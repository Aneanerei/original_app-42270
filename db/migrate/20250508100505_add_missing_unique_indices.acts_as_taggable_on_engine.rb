class AddMissingUniqueIndices < ActiveRecord::Migration[6.0]
  def self.up
    add_index ActsAsTaggableOn.tags_table, :name, unique: true unless index_exists?(ActsAsTaggableOn.tags_table, :name)

    # remove_index 行はコメントアウト済みでOK
    # remove_index ActsAsTaggableOn.taggings_table, :tag_id

    add_index ActsAsTaggableOn.taggings_table,
              %i[tag_id taggable_id taggable_type context tagger_id tagger_type],
              unique: true, name: 'taggings_idx' unless index_exists?(ActsAsTaggableOn.taggings_table, 
              [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type], name: 'taggings_idx')
  end

  def self.down
    # 任意（削除するなら remove_index）
  end
end