class HomesController < ApplicationController
  def index
    @date = params[:year] && params[:month] ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.today.beginning_of_month

    month_start = @date.beginning_of_month
    month_end   = @date.end_of_month

    @incomes = current_user.incomes.where(date: month_start..month_end).order(date: :desc, created_at: :desc)
    @grouped_incomes = @incomes.group_by(&:date)

    @expenses = current_user.expenses.where(date: month_start..month_end).order(date: :desc, created_at: :desc)
    @grouped_expenses = @expenses.group_by(&:date)

    @work_times = current_user.work_times.where(date: month_start..month_end).order(date: :desc, created_at: :desc)
    @grouped_work_times = @work_times.group_by(&:date)

    @total_income = @incomes.sum(:amount)
    @total_expense = @expenses.sum(:amount)
    @balance = @total_income - @total_expense

    # カテゴリ別収入合計（カテゴリ名→金額）
    income_raw = current_user.incomes
                  .where(date: month_start..month_end)
                  .group(:category_income_id)
                  .sum(:amount)

    @income_summary = income_raw.transform_keys do |id|
      CategoryIncome.find_by(id: id)&.name || "未分類"
    end.sort_by { |_, amount| -amount }.to_h

    # カテゴリ別支出合計（カテゴリ名→金額）
    expense_raw = current_user.expenses
                   .where(date: month_start..month_end)
                   .group(:category_expense_id)
                   .sum(:amount)

    @expense_summary = expense_raw.transform_keys do |id|
      CategoryExpense.find_by(id: id)&.name || "未分類"
    end.sort_by { |_, amount| -amount }.to_h

    # 上位3カテゴリ（収入・支出）
    @top_incomes = @income_summary.to_a.first(3)
    @top_expenses = @expense_summary.to_a.first(3)

    # 目標設定モーダル
    today = Date.today
    start_date = today.beginning_of_month
    end_date = today.end_of_month

    @monthly_goal = current_user.monthly_goals.find_by(year: today.year, month: today.month)
    @income_goal = @monthly_goal&.income_goal.to_i
    @savings_goal = @monthly_goal&.savings_goal.to_i

    @income_total = current_user.incomes.where(date: start_date..end_date).sum(:amount)
    @expense_total = current_user.expenses.where(date: start_date..end_date).sum(:amount)
    @actual_saving = @income_total - @expense_total

    @income_progress = if @income_goal.positive?
                       [(@income_total.to_f / @income_goal * 100).round, 200].min
                     else 0 end

    @savings_progress = if @savings_goal.positive?
                        [(@actual_saving.to_f / @savings_goal * 100).round, 200].min
                      else 0 end
  end
end
