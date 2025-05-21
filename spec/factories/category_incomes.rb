FactoryBot.define do
  factory :category_income do
    sequence(:name) { |n| "収入カテゴリ#{n}" }
    user
  end
end
