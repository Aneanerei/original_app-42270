class AddMissingTaggableIndex < ActiveRecord::Migration[6.0]
  def self.up
    unless index_exists?(:taggings, [:taggable_id, :taggable_type, :context], name: 'taggings_taggable_context_idx')
      add_index :taggings, [:taggable_id, :taggable_type, :context], name: 'taggings_taggable_context_idx'
    end
  end

  def self.down
    if index_exists?(:taggings, [:taggable_id, :taggable_type, :context], name: 'taggings_taggable_context_idx')
      remove_index :taggings, name: 'taggings_taggable_context_idx'
    end
  end
end