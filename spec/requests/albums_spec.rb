require 'rails_helper'

RSpec.describe "AlbumsController", type: :request do
  let(:user) { create(:user) }

  let(:auth_headers) do
    basic_user = ENV["BASIC_AUTH_USER"]
    basic_pass = ENV["BASIC_AUTH_PASSWORD"]

    raise "環境変数 BASIC_AUTH_USER / BASIC_AUTH_PASSWORD が未設定です" unless basic_user && basic_pass

    {
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(
        basic_user,
        basic_pass
      )
    }
  end

  before do
    sign_in user
  end

  describe "GET /albums" do
    it "正常に表示される" do
      get albums_path, headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    it "画像がattachedされているものだけが表示される" do
      create(:tagged_image, :with_image,
        expense: create(:expense, user: user, memo: "表示画像"))

      tagged = FactoryBot.build(:tagged_image,
        expense: create(:expense, user: user, memo: "非表示画像"))
      tagged.image.detach if tagged.image.attached?
      tagged.tag_list = nil
      tagged.save!(validate: false)

      get albums_path, headers: auth_headers
      expect(response.body).to include("表示画像")
      expect(response.body).not_to include("非表示画像")
    end

    it "タグ指定で画像が絞り込まれる" do
      create(:tagged_image, :with_image,
        expense: create(:expense, user: user, memo: "旅行画像"),
        tag_list: ["旅行"])
      create(:tagged_image, :with_image,
        expense: create(:expense, user: user, memo: "食事画像"),
        tag_list: ["食事"])

      get albums_path, params: { tag: "旅行" }, headers: auth_headers
      expect(response.body).to include("旅行画像")
      expect(response.body).not_to include("食事画像")
    end

    it "キーワード検索（AND検索）が機能する" do
      create(:tagged_image, :with_image,
        expense: create(:expense, user: user, memo: "旅行夏画像"),
        tag_list: ["旅行", "夏"])
      create(:tagged_image, :with_image,
        expense: create(:expense, user: user, memo: "旅行のみ画像"),
        tag_list: ["旅行"])

      get albums_path, params: { search: "旅行 夏" }, headers: auth_headers
      expect(response.body).to include("旅行夏画像")
      expect(response.body).not_to include("旅行のみ画像")
    end

    it "キーワード検索（OR検索）が機能する" do
      create(:tagged_image, :with_image,
        expense: create(:expense, user: user, memo: "OR旅行画像"),
        tag_list: ["旅行"])
      create(:tagged_image, :with_image,
        expense: create(:expense, user: user, memo: "ORグルメ画像"),
        tag_list: ["グルメ"])
      create(:tagged_image, :with_image,
        expense: create(:expense, user: user, memo: "除外画像"),
        tag_list: ["その他"])

      get albums_path, params: { search: "旅行,グルメ" }, headers: auth_headers
      expect(response.body).to include("OR旅行画像")
      expect(response.body).to include("ORグルメ画像")
      expect(response.body).not_to include("除外画像")
    end
  end
end
