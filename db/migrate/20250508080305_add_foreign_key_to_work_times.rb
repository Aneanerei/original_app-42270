class AddForeignKeyToWorkTimes < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :work_times, :category_work_times
  end
end