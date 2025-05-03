class CreateCategoryWorkTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :category_work_times do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.boolean :default

      t.timestamps
    end
  end
end
