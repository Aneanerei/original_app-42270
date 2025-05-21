# spec/factories/category_work_times.rb
FactoryBot.define do
  factory :category_work_time do
    sequence(:name) { |n| "カテゴリ#{n}" }
    user
  end
end
