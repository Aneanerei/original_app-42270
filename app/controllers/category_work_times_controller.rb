class CategoryWorkTimesController < ApplicationController
  before_action :set_category_work_time, only: [:edit, :update, :destroy]

  def create
    @category_work_time = current_user.category_work_times.build(category_work_time_params)

    if @category_work_time.save
      redirect_to new_work_time_path, notice: "カテゴリを追加しました"
    else
      @work_time = current_user.work_times.new
      @income = current_user.incomes.new

      @category_work_times = CategoryWorkTime.where(user_id: nil)
        .or(CategoryWorkTime.where(user_id: current_user.id))
        .order(:id)

      @category_incomes = CategoryIncome.where(user_id: nil)
        .or(CategoryIncome.where(user_id: current_user.id))
        .order(:id)

      render 'incomes/new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category_work_time.user_id.nil?
      redirect_to new_work_time_path, alert: "このカテゴリは変更できません"
    elsif @category_work_time.update(category_work_time_params)
      redirect_to new_work_time_path, notice: 'カテゴリを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    delete_category(@category_work_time)
  end
  
  def delete_selected
    category = current_user.category_work_times.find_by(id: params[:category_work_time][:category_id])
    delete_category(category)
  end
  
  private
  
  def delete_category(category)
    if category.nil?
      redirect_to new_work_time_path, alert: "カテゴリが見つかりません"
      return
    end
  
    if category.user_id.nil?
      redirect_to new_work_time_path, alert: "このカテゴリは削除できません"
      return
    end
  
    if category.work_times.exists?
      redirect_to new_work_time_path, alert: "このカテゴリは労働時間が登録されているため削除できません"
      return
    end
  
    if category.destroy
      redirect_to new_work_time_path, notice: "カテゴリを削除しました"
    else
      fallback_render_with_errors("カテゴリの削除に失敗しました")
    end
  end
  

  # プルダウン削除機能
  def delete_selected
    category = current_user.category_incomes.find_by(id: params[:category_id])
  
    if category.nil?
      redirect_to new_income_path, alert: "カテゴリが見つかりません"
      return
    end
  
    if category.incomes.exists?
      redirect_to new_income_path, alert: "このカテゴリは収入が登録されているため削除できません"
      return
    end
  
    if category.destroy
      redirect_to new_income_path, notice: "カテゴリを削除しました"
    else
      redirect_to new_income_path, alert: "カテゴリの削除に失敗しました"
    end
  end
  

  # プルダウン編集機能
  def update_selected
    category = current_user.category_work_times.find_by(id: params[:category_work_time][:category_id])

    if category&.user_id.nil?
      redirect_to new_work_time_path, alert: "このカテゴリは変更できません"
    elsif category.present? && category.update(name: params[:category_work_time][:name])
      redirect_to new_work_time_path, notice: "カテゴリを更新しました"
    else
      redirect_to new_work_time_path, alert: "カテゴリの更新に失敗しました"
    end
  end

  private

  def set_category_work_time
    @category_work_time = current_user.category_work_times.find(params[:id])
  end

  def category_work_time_params
    params.require(:category_work_time).permit(:name)
  end
end
