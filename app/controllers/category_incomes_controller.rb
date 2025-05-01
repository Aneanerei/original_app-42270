class CategoryIncomesController < ApplicationController
  def create
    @category_income = current_user.category_incomes.build(category_income_params)
    if @category_income.save
      redirect_to new_income_path, notice: "カテゴリを追加しました"
    else
      @income = Income.new # incomeフォーム用（必須）
      render "incomes/new", status: :unprocessable_entity
    end
  end

  private

  def category_income_params
    params.require(:category_income).permit(:name)
  end
end
