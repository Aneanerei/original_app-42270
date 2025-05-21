FactoryBot.define do
  factory :tagged_image do
    association :expense

    after(:build) do |tagged_image|
      tagged_image.image.attach(
        io: File.open(Rails.root.join('spec/fixtures/sample.jpg')),
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end

    tag_list { "タグA, タグB" }

    # 明示的に「画像付き」として使えるようtraitを定義（中身は空でOK）
    trait :with_image do
      # no-op: デフォルトですでに画像が添付される
    end

    # タグなし（画像のみ）
    trait :without_tags do
      tag_list { nil }
    end


    # 両方なし（バリデーション通らないので注意）
    trait :without_image_and_tags do
      after(:build) do |tagged_image|
        tagged_image.image.detach if tagged_image.image.attached?
        tagged_image.tag_list = nil
      end
    end
  end
end
