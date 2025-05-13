class MonthlyGoalsController < ApplicationController
  before_action :authenticate_user!

  def create
    @monthly_goal = current_user.monthly_goals.find_or_initialize_by(year: goal_params[:year], month: goal_params[:month])
    if @monthly_goal.update(goal_params)
      redirect_to root_path, notice: "目標を設定しました"
    else
      redirect_to root_path, alert: @monthly_goal.errors.full_messages.to_sentence
    end
  end

  private

  def goal_params
    params.require(:monthly_goal).permit(:year, :month, :income_goal, :savings_goal)
  end
end