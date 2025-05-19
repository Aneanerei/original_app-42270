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
  end
end
