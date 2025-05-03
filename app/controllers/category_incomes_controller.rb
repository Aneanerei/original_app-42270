class CategoryIncomesController < ApplicationController
  def create
    @category_income = current_user.category_incomes.build(category_income_params)
  
    if @category_income.save
      redirect_to new_income_path, notice: "カテゴリを追加しました"
    else
      @income = current_user.incomes.new
      @work_time = current_user.work_times.new
  
      @category_incomes = CategoryIncome.where(user_id: nil)
        .or(CategoryIncome.where(user_id: current_user.id))
        .order(:id)
  
      @category_work_times = CategoryWorkTime.where(user_id: nil)
        .or(CategoryWorkTime.where(user_id: current_user.id))
        .order(:id)
  
      render 'incomes/new', status: :unprocessable_entity
    end
  end

  def destroy
    @category_income = current_user.category_incomes.find(params[:id])

    if @category_income.destroy
      redirect_to new_income_path, notice: "カテゴリを削除しました"
    else
      redirect_to new_income_path, alert: @category_income.errors.full_messages.to_sentence
    end
  end

  private

  def category_income_params
    params.require(:category_income).permit(:name)
  end
end
