# OK：sequence を使って毎回異なるメールにする
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    nickname { "テストユーザー" }
  end
end
