class AddCategoryWorkTimeIdToWorkTimes < ActiveRecord::Migration[7.1]
  def change
    add_column :work_times, :category_work_time_id, :integer
  end
end
