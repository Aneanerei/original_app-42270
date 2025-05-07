class CreateIncomes < ActiveRecord::Migration[7.1]
  create_table :incomes do |t|
    t.date :date, null: false
    t.integer :amount, null: false
    t.references :category_income, null: false, foreign_key: true
    t.integer :labor_time
    t.text :memo
    t.references :user, null: false, foreign_key: true
  
    t.timestamps
  end
  
  add_check_constraint :incomes, "amount >= 0", name: "check_amount_non_negative"
end
