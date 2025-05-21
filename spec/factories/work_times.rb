FactoryBot.define do
  factory :work_time do
    association :user
    association :category_work_time
    date { Date.today }
    minutes { 120 }
  end
end
