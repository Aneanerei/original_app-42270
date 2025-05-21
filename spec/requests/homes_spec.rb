require 'rails_helper'

RSpec.describe "HomesController", type: :request do
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

  describe "GET /" do
    it "indexが正常に表示されること" do
      get root_path, headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /homes/category_variation_alert" do
    it "カテゴリ別変動情報がJSONで返ること" do
      create(:income, user: user, date: Date.today.beginning_of_month, amount: 5000)
      get category_variation_alert_homes_path, params: { month: Date.today.strftime("%Y-%m") }, headers: auth_headers
      json = JSON.parse(response.body)
      expect(json).to include("month_label", "income_total", "expense_total")
    end
  end

  describe "GET /homes/day_summary" do
    it "日別データがJSONで返ること" do
      date = Date.today
      create(:expense, user: user, date: date, amount: 1000)
      get day_summary_homes_path, params: { date: date.to_s }, headers: auth_headers
      json = JSON.parse(response.body)
      expect(json).to include("date", "incomes", "expenses", "images", "work_times")
    end
  end
end
