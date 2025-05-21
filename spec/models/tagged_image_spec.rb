require 'rails_helper'

RSpec.describe TaggedImage, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category_expense, user: user) }
  let(:expense) { FactoryBot.create(:expense, user: user, category_expense: category) }

  def uploaded_image
    Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/sample.jpg"), "image/jpeg")
  end

  describe "バリデーション" do
    it "画像があればタグなしでも有効" do
      tagged = TaggedImage.new(
        expense: expense,
        image: uploaded_image,
        tag_list: nil
      )
      expect(tagged).to be_valid
    end

    it "タグがあるが画像がなければ無効" do
      tagged = TaggedImage.new(
        expense: expense,
        image: nil,
        tag_list: "タグA"
      )
      expect(tagged).not_to be_valid
      expect(tagged.errors.full_messages.join).to include("タグは画像がある場合に入力してください")
    end

    it "画像もタグもなければ無効" do
      tagged = TaggedImage.new(
        expense: expense,
        image: nil,
        tag_list: nil
      )
      expect(tagged).not_to be_valid
      expect(tagged.errors.full_messages.join).to include("画像またはタグのいずれかを入力してください")
    end
  end
end
