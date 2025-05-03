class AddCategoryWorkTimeIdToWorkTimes < ActiveRecord::Migration[7.1]
  def change
    add_reference :work_times, :category_work_time, null: false, foreign_key: true
  end
end
