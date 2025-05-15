class IncomesController < ApplicationController
  before_action :set_income, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:new, :create, :edit, :update]

  def new
    @income = current_user.incomes.new
    @work_time = current_user.work_times.new
    @category_income = current_user.category_incomes.build
  end

  def create
    @income = current_user.incomes.new(income_params)

    if @income.save
      redirect_to root_path, notice: "収入を登録しました"
    else
      @work_time = current_user.work_times.new
      @category_income = current_user.category_incomes.build
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # set_income + set_categories により変数は用意済み
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

  def set_categories
    @category_incomes = CategoryIncome.where(user_id: nil)
      .or(CategoryIncome.where(user_id: current_user.id))
      .order(:id)

    @category_work_times = CategoryWorkTime.where(user_id: nil)
      .or(CategoryWorkTime.where(user_id: current_user.id))
      .order(:id)
  end
end
