FactoryBot.define do
  factory :monthly_goal do
    user
    year { 2025 }
    month { 5 }
    income_goal { 100_000 }
    savings_goal { 50_000 }
  end
end



