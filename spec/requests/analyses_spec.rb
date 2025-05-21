require 'rails_helper'

RSpec.describe "AnalysesController", type: :request do
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

    (1..2).each do |month|
      create(:income, user: user, date: Date.new(2025, month, 10), amount: 10000 * month)
      create(:expense, user: user, date: Date.new(2025, month, 15), amount: 5000 * month)

      category = create(:category_work_time, user: user, name: "カテゴリ#{month}")
      create(:work_time, user: user, date: Date.new(2025, month, 5), minutes: 60 * month, category_work_time: category)
    end
  end

  it "レスポンスが成功する" do
    get analyses_path, params: { year: 2025 }, headers: auth_headers
    expect(response).to have_http_status(:ok)
  end

  it "HTMLに月別収入が含まれている（例：20000円）" do
    get analyses_path, params: { year: 2025 }, headers: auth_headers
    expect(response.body).to include("20000")
  end

  it "HTMLに月別支出が含まれている（例：5000円）" do
    get analyses_path, params: { year: 2025 }, headers: auth_headers
    expect(response.body).to include("5000")
  end

  it "HTMLに貯金額が含まれている（例：15000円）" do
  get analyses_path, headers: auth_headers
  expect(response.body).to match(/15,?000 ?円/)
  end

  it "HTMLにカテゴリ別労働時間が含まれている（例：2.0h）" do
  get analyses_path, headers: auth_headers
  expect(response.body).to match(/カテゴリ2.*2\.0/)
  end



  it "HTMLにカテゴリラベル（カテゴリ1 など）が表示されている" do
    get analyses_path, params: { year: 2025 }, headers: auth_headers
    expect(response.body).to include("カテゴリ1")
    expect(response.body).to include("カテゴリ2")
  end
end
