CategoryIncome::DEFAULT_CATEGORY_NAMES.each do |name|
CategoryIncome.find_or_create_by!(name: name, user_id: nil)
end

CategoryWorkTime::DEFAULT_CATEGORY_NAMES.each do |name|
CategoryWorkTime.find_or_create_by!(name: name, user_id: nil)
end

expense_categories = [
  "食費", "外食費", "交通費", "衣服", "交際費", "通信費",
  "日用品", "税金", "医療費", "保険", "光熱費", "住居費", "趣味"
]

expense_categories.each do |name|
  CategoryExpense.find_or_create_by!(name: name, user_id: nil)
end