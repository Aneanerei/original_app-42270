FactoryBot.define do
  factory :expense do
    association :user
    association :category_expense
    date { Date.today }
    amount { 1500 }
    memo { "メモ内容" }

    trait :with_tagged_image do
      after(:build) do |expense|
        expense.tagged_images << FactoryBot.build(:tagged_image, expense: expense)
      end
    end
  end
end
