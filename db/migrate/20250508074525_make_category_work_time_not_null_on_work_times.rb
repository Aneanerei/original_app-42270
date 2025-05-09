class MakeCategoryWorkTimeNotNullOnWorkTimes < ActiveRecord::Migration[7.1]
  def change
    change_column_null :work_times, :category_work_time_id, false
  end
end
