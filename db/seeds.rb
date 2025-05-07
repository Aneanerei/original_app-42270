CategoryIncome::DEFAULT_CATEGORY_NAMES.each do |name|
CategoryIncome.find_or_create_by!(name: name, user_id: nil)
end

CategoryWorkTime::DEFAULT_CATEGORY_NAMES.each do |name|
CategoryWorkTime.find_or_create_by!(name: name, user_id: nil)
end