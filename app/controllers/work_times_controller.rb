class WorkTimesController < ApplicationController
  before_action :authenticate_user!

  def new
    @work_time = WorkTime.new
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
        @category_income = CategoryIncome.new
        render 'incomes/new', status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def destroy
    work_time = current_user.work_times.find(params[:id])
    work_time.destroy
    redirect_to root_path, notice: "労働時間を削除しました"
  end
  
  private
  
  def work_time_params
    params.require(:work_time).permit(:date, :minutes, :report, :category_income_id)
  end
end