class AddDefaultToCategoryIncomes < ActiveRecord::Migration[7.1]
  def change
    add_column :category_incomes, :default, :boolean
  end
end
