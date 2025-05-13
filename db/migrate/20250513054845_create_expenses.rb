class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.date :date, null: false
      t.integer :amount, null: false
      t.integer :category_expense_id, null: false
      t.text :memo
      t.string :tag_list
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end