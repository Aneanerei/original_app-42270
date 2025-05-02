class IncomesController < ApplicationController
  before_action :authenticate_user!  

  
  def new
    @category_income = CategoryIncome.new
    @income = current_user.incomes.new
  end

  def create 
    hour = params[:labor_hour].to_i
    minute = params[:labor_minute].to_i
    
    @income = current_user.incomes.new(income_params) 
    @income.labor_time = hour * 60 + minute
    
   
   

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

