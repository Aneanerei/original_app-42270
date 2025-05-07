class ChangeUserIdToNullableInCategoryIncomes < ActiveRecord::Migration[7.1]
  def change
    change_column_null :category_incomes, :user_id, true
  end
end
