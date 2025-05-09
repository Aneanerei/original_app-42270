class RemoveCategoryIncomeIdFromWorkTimes < ActiveRecord::Migration[7.1]
  def change
    remove_column :work_times, :category_income_id, :integer
  end
end
