class RemoveLaborTimeFromIncomes < ActiveRecord::Migration[7.1]
  def change
    remove_column :incomes, :labor_time, :integer
  end
end
