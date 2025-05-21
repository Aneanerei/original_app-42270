FactoryBot.define do
  factory :category_expense do
    sequence(:name) { |n| "カテゴリ#{n}" }
    user
  end
end
