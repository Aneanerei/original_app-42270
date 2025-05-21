class WorkReportsController < ApplicationController
    before_action :set_beginning_of_week
  def index
    year  = params[:year]&.to_i || Date.today.year
    month = params[:month]&.to_i || Date.today.month
    @date = Date.new(year, month, 1)
    range = @date.beginning_of_month..@date.end_of_month

    # 労働メモ（日報用）
    work_memo_records = current_user.work_times
      .where(date: range)
      .where.not(report: [nil, ""])
      .includes(:category_work_time)

    @grouped_worktimes = work_memo_records.group_by(&:date)

    # 収入メモ（日報用）
    income_memo_records = current_user.incomes
      .where(date: range)
      .where.not(memo: [nil, ""])
      .includes(:category_income)

    @grouped_incomes = income_memo_records.group_by(&:date)

    # バッジ用カテゴリ（労働）
    @labor_categories = CategoryWorkTime.where(user_id: nil)
      .or(CategoryWorkTime.where(user_id: current_user))
      .distinct
      .pluck(:name)

    # 労働時間テーブル（右ページ用）
    @work_times = current_user.work_times
      .where(date: range)
      .includes(:category_work_time)

    # カテゴリ別労働時間サマリー
    @worktime_summary = @work_times
      .joins(:category_work_time)
      .group('category_work_times.name')
      .sum(:minutes)

    # 表示日付統合（降順）
    @combined_dates = (@grouped_worktimes.keys + @grouped_incomes.keys).uniq.sort.reverse

    # 祝日
    @holidays = HolidayJp.between(@date.beginning_of_month, @date.end_of_month).index_by(&:date)

  end
  private

  def set_beginning_of_week
    Date.beginning_of_week = :sunday
  end
end
