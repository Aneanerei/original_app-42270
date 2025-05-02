class HomesController < ApplicationController
  def index
    @date = params[:year] && params[:month] ? Date.new(params[:year].to_i, params[:month].to_i, 1) : Date.today.beginning_of_month
  
    # 月初〜月末を定義
    month_start = @date.beginning_of_month
    month_end   = @date.end_of_month
  
    # その月の収入・支出を取得
    @incomes = current_user.incomes.where(date: month_start..month_end).order(date: :desc)
    @grouped_incomes = @incomes.group_by(&:date)
    # @expenses = current_user.expenses.where(date: month_start..month_end).order(:date)
  end
end
