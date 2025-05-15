class HomesController < ApplicationController
  before_action :set_beginning_of_week

  def index
    # 表示対象年月（指定がなければ今月）
    @date = params[:year] && params[:month] ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.today.beginning_of_month
    month_start = @date.beginning_of_month
    month_end = @date.end_of_month

    # 今月の収入・支出・労働時間を取得
    @incomes = current_user.incomes.where(date: month_start..month_end).order(date: :desc, created_at: :desc)
    @expenses = current_user.expenses.where(date: month_start..month_end).order(date: :desc, created_at: :desc)
    @work_times = current_user.work_times.where(date: month_start..month_end).order(date: :desc, created_at: :desc)

    # 日別にグループ化
    @grouped_incomes = @incomes.group_by(&:date)
    @grouped_expenses = @expenses.group_by(&:date)
    @grouped_work_times = @work_times.group_by(&:date)

    # 祝日
    @holidays = HolidayJp.between(month_start, month_end).index_by(&:date)

    # 合計金額
    @total_income = @incomes.sum(:amount)
    @total_expense = @expenses.sum(:amount)
    @balance = @total_income - @total_expense

    # カテゴリ別集計
    @income_summary = summarize_by_category(current_user.incomes.where(date: month_start..month_end), :category_income_id, CategoryIncome)
    @expense_summary = summarize_by_category(current_user.expenses.where(date: month_start..month_end), :category_expense_id, CategoryExpense)

    # トップカテゴリ
    @top_incomes = @income_summary.to_a.first(3)
    @top_expenses = @expense_summary.to_a.first(3)

    # 表示年月（目標・進捗用）
    @selected_year = params[:year]&.to_i || Date.today.year
    @selected_month = params[:month]&.to_i || Date.today.month
    start_date = Date.new(@selected_year, @selected_month, 1)
    end_date = start_date.end_of_month

    # 月次目標
    @monthly_goal = current_user.monthly_goals.find_by(year: @selected_year, month: @selected_month)
    @income_goal = @monthly_goal&.income_goal
    @savings_goal = @monthly_goal&.savings_goal

    # 実績（収入・支出・貯金）
    @income_total = current_user.incomes.where(date: start_date..end_date).sum(:amount)
    @expense_total = current_user.expenses.where(date: start_date..end_date).sum(:amount)
    @actual_saving = @income_total - @expense_total

    # 達成率（最大300%までで切り上げ）
    @income_progress = calculate_progress(@income_total, @income_goal)
    @savings_progress = calculate_progress(@actual_saving, @savings_goal)

    # メーター最大値（100か300）
    @income_meter_max = case @income_progress
                    when 0..100 then 100
                    when 101..200 then 200
                    else 300
                    end
    @savings_meter_max = case @savings_progress
                    when 0..100 then 100
                    when 101..200 then 200
                    else 300
                    end

    # 残り金額・日数・日割り
    @income_remaining = [@income_goal.to_f - @income_total, 0].max
    @savings_remaining = [@savings_goal.to_f - @actual_saving, 0].max
    today = Date.today
    @days_left = [(end_date - today).to_i + 1, 1].max
    @income_daily_target = @income_remaining.positive? ? (@income_remaining / @days_left.to_f).ceil : 0
    @savings_daily_target = @savings_remaining.positive? ? (@savings_remaining / @days_left.to_f).ceil : 0
 
 
    @worktime_summary = current_user.work_times
      .where(date: month_start..month_end)
      .joins(:category_work_time)
      .group("category_work_times.name")
      .sum(:minutes)

 
 
 
 
  end

  private

  def set_beginning_of_week
    Date.beginning_of_week = :sunday
  end

  def summarize_by_category(records, category_key, category_model)
    raw = records.group(category_key).sum(:amount)
    raw.transform_keys { |id| category_model.find_by(id: id)&.name || "未分類" }
       .sort_by { |_, amt| -amt }.to_h
  end

  def calculate_progress(actual, goal)
    return 0 unless goal.to_f.positive?
    [(actual / goal.to_f * 100).round, 300].min
  end
end
