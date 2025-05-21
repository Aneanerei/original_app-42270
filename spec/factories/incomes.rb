FactoryBot.define do
  factory :income do
    association :user
    association :category_income
    date { Date.today }
    amount { 100_000 }
  end
end