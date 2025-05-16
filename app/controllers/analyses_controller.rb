class AnalysesController < ApplicationController
  def index
    @year = (params[:year] || Date.today.year).to_i
    start_date = Date.new(@year, 1, 1)
    end_date = start_date.end_of_year

    @incomes = current_user.incomes.where(date: start_date..end_date)
    @expenses = current_user.expenses.where(date: start_date..end_date)
    @work_times = current_user.work_times.where(date: start_date..end_date)

    # 収入・支出・貯金
    @monthly_income_totals = (1..12).map do |month|
      range = Date.new(@year, month, 1)..Date.new(@year, month, -1)
      ["#{month}月", @incomes.where(date: range).sum(:amount)]
    end.to_h
    max_income = @monthly_income_totals.values.max || 0
    @y_step_size = (max_income / 10.0).ceil

    @monthly_expense_totals = (1..12).map do |month|
      range = Date.new(@year, month, 1)..Date.new(@year, month, -1)
      ["#{month}月", @expenses.where(date: range).sum(:amount)]
    end.to_h
    max_expense = @monthly_expense_totals.values.max || 0
    @y_step_size_expense = (max_expense / 10.0).ceil

    @monthly_savings_totals = (1..12).map do |month|
      label = "#{month}月"
      income = @monthly_income_totals[label] || 0
      expense = @monthly_expense_totals[label] || 0
      [label, income - expense]
    end.to_h
    max_saving = @monthly_savings_totals.values.max || 0
    @y_step_size_saving = (max_saving / 10.0).ceil

    # 月別合計労働時間（時間）
    @monthly_worktime_totals = (1..12).map do |month|
      range = Date.new(@year, month, 1)..Date.new(@year, month, -1)
      total_minutes = @work_times.where(date: range).sum(:minutes)
      ["#{month}月", (total_minutes.to_f / 60).round(1)]
    end.to_h

    # 年間カテゴリ別労働時間（時間）
    @worktime_total_by_category = @work_times
      .includes(:category_work_time)
      .joins(:category_work_time)
      .group("category_work_times.name")
      .sum(:minutes)
      .transform_keys(&:to_s)
      .transform_values { |min| (min.to_f / 60).round(1) }

    # 月別カテゴリ別（分単位）
    @worktime_monthly_by_category = {}
    @work_times.each do |wt|
      category = wt.category_work_time&.name || "未分類"
      month_label = wt.date.strftime("%-m月")
      @worktime_monthly_by_category[category] ||= {}
      @worktime_monthly_by_category[category][month_label] ||= 0
      @worktime_monthly_by_category[category][month_label] += wt.minutes
    end

    # Chartkick棒グラフ用データ（時間単位）
    @worktime_chart_for_grouped_bar = @worktime_monthly_by_category.map do |category, month_data|
      formatted = (1..12).map { |m| ["#{m}月", (month_data["#{m}月"] || 0).to_f / 60] }.to_h
      { name: category, data: formatted }
    end

    all_values = @worktime_chart_for_grouped_bar.flat_map { |entry| entry[:data].values }
    max_hours = all_values.max || 0
    @y_step_size_worktime = (max_hours / 10.0).ceil

    # 円グラフ用パーセンテージ付きラベル
    total_minutes = @worktime_total_by_category.values.sum
    @worktime_total_by_category_percentage = @worktime_total_by_category.transform_keys do |name|
      percent = ((@worktime_total_by_category[name] / total_minutes.to_f) * 100).round(1)
      "#{name}（#{percent}%）"
    end

    # 月別カテゴリ別（分→時間）テーブル用データ
    @monthly_category_totals = @worktime_monthly_by_category.transform_values do |month_data|
      month_data.transform_values { |minutes| (minutes.to_f / 60).round(1) }
    end

    @worktime_monthly_table_data = @worktime_monthly_by_category.transform_values do |month_data|
      (1..12).map do |m|
        month = "#{m}月"
        ((month_data[month] || 0).to_f / 60).round(1)
      end
    end

    # 年間の労働時間と労働日数
    total_minutes_all = @work_times.sum(:minutes)
    @total_work_hours = (total_minutes_all.to_f / 60).round(1)
    @total_work_days = @work_times.select(:date).distinct.count

    # 労働統計：カテゴリ別 時間・日数・割合
    @work_stats_by_category = @work_times
      .joins(:category_work_time)
      .group("category_work_times.name")
      .select("category_work_times.name AS name, COUNT(DISTINCT work_times.date) AS days, SUM(work_times.minutes) AS total_minutes")
      .map do |record|
        {
          name: record.name,
          days: record.days,
          hours: (record.total_minutes.to_f / 60).round(1)
        }
      end

    total_hours = @work_stats_by_category.sum { |s| s[:hours] }

    @worktime_ratios = @work_stats_by_category.map do |entry|
      percentage = total_hours > 0 ? ((entry[:hours] / total_hours.to_f) * 100).round(1) : 0
      entry.merge(percentage: percentage)
    end
  end
end