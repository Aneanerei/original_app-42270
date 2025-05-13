class AddForeignKeyToWorkTimes < ActiveRecord::Migration[7.1]
 def change
    # エラー回避：すでにあるか確認してから追加
    unless foreign_key_exists?(:work_times, :category_work_times)
      add_foreign_key :work_times, :category_work_times
    end
end
