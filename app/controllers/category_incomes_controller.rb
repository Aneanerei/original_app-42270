class CategoryIncomesController < ApplicationController

  def create
    @category_income = current_user.category_incomes.new(category_income_params)

    if @category_income.save
      redirect_to request.referer || root_path, notice: "カテゴリを追加しました"
    else
      @income = Income.new
      @work_time = WorkTime.new
      render 'incomes/new', status: :unprocessable_entity
    end
  end

  private

  def category_income_params
    params.require(:category_income).permit(:name)
  end
end
