class CreateMonthlyGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :monthly_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :year
      t.integer :month
      t.integer :income_goal
      t.integer :savings_goal

      t.timestamps
    end
  end
end
