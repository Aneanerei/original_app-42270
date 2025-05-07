class CategoryWorkTimesController < ApplicationController
  before_action :set_category_work_time, only: [:edit, :update, :destroy]

  def create
    @category_work_time = current_user.category_work_times.build(category_work_time_params)

    if @category_work_time.save
      redirect_to new_income_path, alert: "カテゴリを追加しました"
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
      redirect_to new_income_path, alert: "このカテゴリは変更できません"
    elsif @category_work_time.update(category_work_time_params)
      redirect_to new_income_path, alert: 'カテゴリを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category_work_time.user_id.nil?
      redirect_to new_income_path, alert: "このカテゴリは削除できません"
    elsif @category_work_time.work_times.exists?
      redirect_to new_income_path, alert: "このカテゴリには登録された労働時間があるため削除できません"
    elsif @category_work_time.destroy
      redirect_to new_income_path, alert: "カテゴリを削除しました"
    else
      redirect_to new_income_path, alert: @category_work_time.errors.full_messages.to_sentence
    end
  end
  

  def delete_selected
    category = current_user.category_work_times.find_by(id: params[:category_work_time][:category_id])
  
    if category&.user_id.nil?
      redirect_to new_income_path, alert: "このカテゴリは削除できません"
    elsif category.work_times.exists?
      redirect_to new_income_path, alert: "このカテゴリには登録された労働時間があるため削除できません"
    elsif category.destroy
      redirect_to new_income_path, alert: "カテゴリを削除しました"
    else
      redirect_to new_income_path, alert: "カテゴリの削除に失敗しました"
    end
  end

  def update_selected
    category = current_user.category_work_times.find_by(id: params[:category_work_time][:category_id])

    if category&.user_id.nil?
      redirect_to new_income_path, alert: "このカテゴリは変更できません"
    elsif category.present? && category.update(name: params[:category_work_time][:name])
      redirect_to new_income_path, alert: "カテゴリを更新しました"
    else
      redirect_to new_income_path, alert: "カテゴリの更新に失敗しました"
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
