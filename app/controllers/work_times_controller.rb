class WorkTimesController < ApplicationController
  before_action :set_work_time, only: [:edit, :update, :destroy]

  def new
    @work_time = current_user.work_times.new
    @category_work_times = CategoryWorkTime.where(user_id: nil)
      .or(CategoryWorkTime.where(user_id: current_user.id))
      .order(:id)
  end

  def create
    hour = params[:labor_hour].to_i
    minute = params[:labor_minute].to_i
    total_minutes = hour * 60 + minute

    @work_time = current_user.work_times.new(work_time_params)
    @work_time.minutes = total_minutes

    if @work_time.save
      redirect_to root_path, notice: "労働時間を登録しました"
    else
      if params[:from_modal].present?
        @income = current_user.incomes.new
        @category_income = current_user.category_incomes.build
        @category_incomes = CategoryIncome.where(user_id: nil)
          .or(CategoryIncome.where(user_id: current_user.id))
          .order(:id)

        @category_work_times = CategoryWorkTime.where(user_id: nil)
          .or(CategoryWorkTime.where(user_id: current_user.id))
          .order(:id)

        render 'incomes/new', status: :unprocessable_entity
      else
        @category_work_times = CategoryWorkTime.where(user_id: nil)
          .or(CategoryWorkTime.where(user_id: current_user.id))
          .order(:id)

        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @category_work_times = CategoryWorkTime.where(user_id: nil)
      .or(CategoryWorkTime.where(user_id: current_user.id))
      .order(:id)
  end

  def update
    hour = params[:labor_hour].to_i
    minute = params[:labor_minute].to_i
    total_minutes = hour * 60 + minute
    @work_time.minutes = total_minutes

    if @work_time.update(work_time_params)
      redirect_to root_path, notice: "労働時間を更新しました"
    else
      @category_work_times = CategoryWorkTime.where(user_id: nil)
        .or(CategoryWorkTime.where(user_id: current_user.id))
        .order(:id)

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
end
