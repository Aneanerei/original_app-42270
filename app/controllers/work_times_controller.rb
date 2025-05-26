class WorkTimesController < ApplicationController
  before_action :set_work_time, only: [:edit, :update, :destroy]

  def new
    @work_time = current_user.work_times.new
    @category_work_times = load_category_work_times
  end

  def create
    hour = params[:labor_hour].to_i
    minute = params[:labor_minute].to_i
    total_minutes = hour * 60 + minute

    @work_time = current_user.work_times.new(work_time_params)
    @work_time.minutes = total_minutes

    if @work_time.save
      if params[:from_income_modal].present?
        redirect_to new_income_path, notice: "労働時間を登録しました"
      else
        redirect_to root_path, notice: "労働時間を登録しました"
      end
    else
      @category_work_times = load_category_work_times

      if params[:from_income_modal].present?
        # incomes/new に必要な変数を再設定
        @income = current_user.incomes.new
        @category_income = current_user.category_incomes.build
        @category_incomes = load_category_incomes

        render 'incomes/new', status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @category_work_times = load_category_work_times
    @labor_hour = @work_time.minutes / 60
    @labor_minute = @work_time.minutes % 60
  end

  def update
    hour = params[:labor_hour].to_i
    minute = params[:labor_minute].to_i
    total_minutes = hour * 60 + minute
    @work_time.minutes = total_minutes

    if @work_time.update(work_time_params)
      redirect_to root_path, notice: "労働時間を更新しました"
    else
      @category_work_times = load_category_work_times
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @work_time.destroy
    redirect_to root_path, notice: "労働時間を削除しました"
  end

  private

  def set_work_time
    @work_time = current_user.work_times.find(params[:id])
  end

  def work_time_params
    params.require(:work_time).permit(:date, :minutes, :report, :category_work_time_id)
  end

  def load_category_work_times
    CategoryWorkTime.where(user_id: nil).or(CategoryWorkTime.where(user_id: current_user.id)).order(:id)
  end

  def load_category_incomes
    CategoryIncome.where(user_id: nil).or(CategoryIncome.where(user_id: current_user.id)).order(:id)
  end
end
