  class CategoryWorkTimesController < ApplicationController
  
    def create
      @category_work_time = current_user.category_work_times.build(category_work_time_params)
  
      if @category_work_time.save
        redirect_to new_work_time_path, notice: "カテゴリを追加しました"
      else
        @work_time = current_user.work_times.new
        @category_work_times = CategoryWorkTime.where(user_id: nil)
          .or(CategoryWorkTime.where(user_id: current_user.id))
        render 'work_times/new', status: :unprocessable_entity
      end
    end
  
    def destroy
      @category_work_time = current_user.category_work_times.find(params[:id])
  
      if @category_work_time.destroy
        redirect_to new_work_time_path, notice: "カテゴリを削除しました"
      else
        redirect_to new_work_time_path, alert: @category_work_time.errors.full_messages.to_sentence
      end
    end
  
    private
  
    def category_work_time_params
      params.require(:category_work_time).permit(:name)
    end
  end
  

