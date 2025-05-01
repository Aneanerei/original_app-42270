class IncomesController < ApplicationController
  before_action :authenticate_user!  

  def new
    @income = Income.new
    @category_income = CategoryIncome.new
  end

  def create
    @income = current_user.incomes.new(income_params)
    if @income.save
      redirect_to root_path, notice: "収入を登録しました"
    else
      render :new
    end
  end

  private

  def income_params
    params.require(:income).permit(:date, :amount, :category_income_id, :labor_time, :memo)
  end
end

