class HomesController < ApplicationController
  before_action :set_beginning_of_week

  def index
    @date = params[:year] && params[:month] ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.today.beginning_of_month
    month_start = @date.beginning_of_month
    month_end = @date.end_of_month

    @incomes = current_user.incomes.includes(:category_income).where(date: month_start..month_end)
    @expenses = current_user.expenses.includes(:category_expense).where(date: month_start..month_end)
    @work_times = current_user.work_times.where(date: month_start..month_end)

    @grouped_incomes = @incomes.group_by(&:date)
    @grouped_expenses = @expenses.group_by(&:date)
    @grouped_work_times = @work_times.group_by(&:date)

    @holidays = HolidayJp.between(month_start, month_end).index_by(&:date)

    @total_income = @incomes.sum(:amount)
    @total_expense = @expenses.sum(:amount)
    @balance = @total_income - @total_expense

    @income_summary = summarize_by_category(@incomes, :category_income_id, CategoryIncome)
    @expense_summary = summarize_by_category(@expenses, :category_expense_id, CategoryExpense)

    @top_incomes = @income_summary.to_a.first(3)
    @top_expenses = @expense_summary.to_a.first(3)

    @selected_year = params[:year]&.to_i || Date.today.year
    @selected_month = params[:month]&.to_i || Date.today.month
    start_date = Date.new(@selected_year, @selected_month, 1)
    end_date = start_date.end_of_month

    @monthly_goal = current_user.monthly_goals.find_by(year: @selected_year, month: @selected_month)
    @income_goal = @monthly_goal&.income_goal
    @savings_goal = @monthly_goal&.savings_goal

    @income_total = current_user.incomes.where(date: start_date..end_date).sum(:amount)
    @expense_total = current_user.expenses.where(date: start_date..end_date).sum(:amount)
    @actual_saving = @income_total - @expense_total

    @income_progress = calculate_progress(@income_total, @income_goal)
    @savings_progress = calculate_progress(@actual_saving, @savings_goal)

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
def category_variation_alert
  user = current_user

  # クエリパラメータから比較月を取得（例: "2025-05"）
  compare_month = params[:month].present? ? Date.parse("#{params[:month]}-01") : Date.today.last_month
  prev_month = compare_month - 1.month

  compare_range = compare_month.beginning_of_month..compare_month.end_of_month
  prev_range = prev_month.beginning_of_month..prev_month.end_of_month

  # 総額の取得（未登録でもゼロになる）
  income_now = user.incomes.where(date: compare_range).sum(:amount)
  income_prev = user.incomes.where(date: prev_range).sum(:amount)
  expense_now = user.expenses.where(date: compare_range).sum(:amount)
  expense_prev = user.expenses.where(date: prev_range).sum(:amount)

  # 早期リターン（完全にデータがない月の場合）
  if income_now.zero? && income_prev.zero? && expense_now.zero? && expense_prev.zero?
    return render json: {
      month_label: compare_month.strftime("%Y年%m月"),
      income_total: { current: 0, previous: 0, diff: 0 },
      expense_total: { current: 0, previous: 0, diff: 0 },
      income_category_change: {
        category: "データなし", current: 0, previous: 0, diff: 0, abs_diff: 0
      },
      expense_category_change: {
        category: "データなし", current: 0, previous: 0, diff: 0, abs_diff: 0
      }
    }
  end

  # カテゴリ別収入
  income_now_group = user.incomes.where(date: compare_range).group(:category_income_id).sum(:amount)
  income_prev_group = user.incomes.where(date: prev_range).group(:category_income_id).sum(:amount)
  income_cat_ids = (income_now_group.keys + income_prev_group.keys).uniq
  income_categories = CategoryIncome.where(id: income_cat_ids).index_by(&:id)

  income_variations = income_cat_ids.map do |id|
    current = income_now_group[id] || 0
    previous = income_prev_group[id] || 0
    diff = current - previous
    {
      category: income_categories[id]&.name || "不明",
      current: current,
      previous: previous,
      diff: diff,
      abs_diff: diff.abs
    }
  end

  top_income_change = income_variations.max_by { |v| v[:abs_diff] }

  # カテゴリ別支出
  expense_now_group = user.expenses.where(date: compare_range).group(:category_expense_id).sum(:amount)
  expense_prev_group = user.expenses.where(date: prev_range).group(:category_expense_id).sum(:amount)
  expense_cat_ids = (expense_now_group.keys + expense_prev_group.keys).uniq
  expense_categories = CategoryExpense.where(id: expense_cat_ids).index_by(&:id)

  expense_variations = expense_cat_ids.map do |id|
    current = expense_now_group[id] || 0
    previous = expense_prev_group[id] || 0
    diff = current - previous
    {
      category: expense_categories[id]&.name || "不明",
      current: current,
      previous: previous,
      diff: diff,
      abs_diff: diff.abs
    }
  end

  top_expense_change = expense_variations.max_by { |v| v[:abs_diff] }

  render json: {
    month_label: compare_month.strftime("%Y年%m月"),
    income_total: {
      current: income_now,
      previous: income_prev,
      diff: income_now - income_prev
    },
    expense_total: {
      current: expense_now,
      previous: expense_prev,
      diff: expense_now - expense_prev
    },
    income_category_change: top_income_change || {
      category: "データなし", current: 0, previous: 0, diff: 0, abs_diff: 0
    },
    expense_category_change: top_expense_change || {
      category: "データなし", current: 0, previous: 0, diff: 0, abs_diff: 0
    }
  }
end


  def day_summary
    date = Date.parse(params[:date])
    user = current_user

    income_entries = user.incomes.where(date: date).includes(:category_income)
    expense_entries = user.expenses.where(date: date).includes(:category_expense)
    tagged_images = TaggedImage.joins(:expense).where(expenses: { user_id: user.id, date: date }).includes(:expense)
    work_time_entries = user.work_times.where(date: date).includes(:category_work_time)

    render json: {
      date: date.strftime("%Y/%m/%d"),
      incomes: income_entries.map { |i|
        {
          category: i.category_income&.name || "不明",
          amount: i.amount,
          memo: i.memo.presence || "（メモなし）"
        }
      },
      expenses: expense_entries.map { |e|
        {
          category: e.category_expense&.name || "不明",
          amount: e.amount,
          memo: e.memo.presence || "（メモなし）"
        }
      },
      images: tagged_images.map { |img|
        {
          url: url_for(img.image),
          memo: img.memo,
          tags: img.tag_list
        }
      },
      work_times: work_time_entries.map { |wt|
        {
          category: wt.category_work_time&.name || "不明",
          duration: wt.minutes.to_i,
          memo: wt.report
        }
      }
    }
  end

  private

  def set_beginning_of_week
    Date.beginning_of_week = :sunday
  end

  def summarize_by_category(records, category_key, category_model)
    category_ids = records.pluck(category_key).uniq.compact
    categories = category_model.where(id: category_ids).index_by(&:id)
    raw = records.group(category_key).sum(:amount)

    raw.transform_keys { |id| categories[id]&.name || "未分類" }
       .sort_by { |_, amt| -amt }
       .to_h
  end

  def calculate_progress(actual, goal)
    return 0 unless goal.to_f.positive?
    [(actual / goal.to_f * 100).round, 300].min
  end
end
