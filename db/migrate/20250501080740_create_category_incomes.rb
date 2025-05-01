class CreateCategoryIncomes < ActiveRecord::Migration[7.1]
  def change
    create_table :category_incomes do |t|
      t.string :name, null: false            # プルダウンに表示するカテゴリ名
      t.references :user, null: false, foreign_key: true  # カテゴリの所有者

      t.timestamps
    end
  end
end
