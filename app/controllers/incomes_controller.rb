class IncomesController < ApplicationController
  before_action :set_income, only: [:edit, :update, :destroy]
  
  def new
    @category_income = CategoryIncome.new
    @income = current_user.incomes.new
    @work_time = WorkTime.new
  end

  def create 
    @income = current_user.incomes.new(income_params) 
  
    if @income.save
      redirect_to root_path, notice: "収入を登録しました"
    else
      @category_income = CategoryIncome.new
      @work_time = WorkTime.new   
      render :new
    end
  end

  def edit
  end

  def update
    if @income.update(income_params)
      redirect_to root_path, notice: "収入を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @income.destroy
    redirect_to root_path, notice: "収入を削除しました"
  end

  private

  def income_params
    params.require(:income).permit(:date, :amount, :category_income_id, :memo)
  end
  
  def set_income
    @income = current_user.incomes.find(params[:id])
  end


end

