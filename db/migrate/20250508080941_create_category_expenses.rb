class CreateCategoryExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :category_expenses do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true 

      t.timestamps
    end

    add_index :category_expenses, [:name, :user_id], unique: true
  end
end