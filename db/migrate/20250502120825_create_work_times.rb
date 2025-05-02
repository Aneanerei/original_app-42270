class CreateWorkTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :work_times do |t|
      t.date :date
      t.integer :minutes
      t.references :user, null: false, foreign_key: true
      t.text :memo

      t.timestamps
    end
  end
end
