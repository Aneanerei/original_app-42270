class AddCategoryIncomeIdToWorkTimes < ActiveRecord::Migration[7.1]
  def change
    add_column :work_times, :category_income_id, :integer
  end
end
