class CreateTaggedImages < ActiveRecord::Migration[7.1]
  def change
    create_table :tagged_images do |t|
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
