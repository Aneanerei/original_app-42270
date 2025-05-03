class ChangeUserIdToNullableInCategoryWorkTimes < ActiveRecord::Migration[7.1]
  def change
    change_column_null :category_work_times, :user_id, true
  end
end
