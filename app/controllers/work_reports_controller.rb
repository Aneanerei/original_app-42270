class WorkReportsController < ApplicationController
  def index
    year  = params[:year]&.to_i || Date.today.year
    month = params[:month]&.to_i || Date.today.month
    @date = Date.new(year, month, 1)
    range = @date.beginning_of_month..@date.end_of_month

    # ✅ 労働時間テーブル表示用：すべて取得
    @work_times = current_user.work_times
      .where(date: range)
      .includes(:category_work_time)
      .order(date: :desc, created_at: :desc)

    # ✅ 日報表示用：メモがあるものだけを抽出してページング
    @work_times_with_report = @work_times
      .where.not(report: [nil, ""])
      .page(params[:page])

    @grouped_worktimes = @work_times_with_report.group_by(&:date)

    respond_to do |format|
      format.html
      format.turbo_stream
    end

    @worktime_summary = current_user.work_times
  .where(date: @date.beginning_of_month..@date.end_of_month)
  .joins(:category_work_time)
  .group('category_work_times.name')
  .sum(:minutes)

   # 表示対象年月（指定がなければ今月）
    @date = params[:year] && params[:month] ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.today.beginning_of_month
    @month_start = @date.beginning_of_month
    @month_end = @date.end_of_month
    @holidays = HolidayJp.between(@date.beginning_of_month, @date.end_of_month).index_by(&:date)
  end




  
end
