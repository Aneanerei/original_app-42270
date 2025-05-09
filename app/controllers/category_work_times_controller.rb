class CategoryWorkTimesController < ApplicationController
  before_action :set_category_work_time, only: [:edit, :update, :destroy]

  def create
    @category_work_time = current_user.category_work_times.build(category_work_time_params)

    if @category_work_time.save
      redirect_to determine_redirect_path, notice: "カテゴリを追加しました"
    else
      prepare_common_variables
      render determine_render_template, status: :unprocessable_entity
    end
  end

  def update
    if @category_work_time.user_id.nil?
      redirect_to determine_redirect_path, alert: "このカテゴリは変更できません"
    elsif @category_work_time.update(category_work_time_params)
      redirect_to determine_redirect_path, notice: "カテゴリを更新しました"
    else
      prepare_common_variables
      render determine_render_template, status: :unprocessable_entity
    end
  end

  def destroy
    if @category_work_time.user_id.nil?
      redirect_to determine_redirect_path, alert: "このカテゴリは削除できません"
    elsif @category_work_time.work_times.exists?
      redirect_to determine_redirect_path, alert: "このカテゴリには登録された労働時間があるため削除できません"
    elsif @category_work_time.destroy
      redirect_to determine_redirect_path, notice: "カテゴリを削除しました"
    else
      redirect_to determine_redirect_path, alert: @category_work_time.errors.full_messages.to_sentence
    end
  end

  def delete_selected
    category = current_user.category_work_times.find_by(id: params.dig(:category_work_time, :category_id))

    if category&.user_id.nil?
      redirect_to determine_redirect_path, alert: "このカテゴリは削除できません"
    elsif category.work_times.exists?
      redirect_to determine_redirect_path, alert: "このカテゴリには登録された労働時間があるため削除できません"
    elsif category.destroy
      redirect_to determine_redirect_path, notice: "カテゴリを削除しました"
    else
      redirect_to determine_redirect_path, alert: "カテゴリの削除に失敗しました"
    end
  end

  def update_selected
    category = current_user.category_work_times.find_by(id: params.dig(:category_work_time, :category_id))

    if category&.user_id.nil?
      redirect_to determine_redirect_path, alert: "このカテゴリは変更できません"
    elsif category.update(name: params.dig(:category_work_time, :name))
      redirect_to determine_redirect_path, notice: "カテゴリを更新しました"
    else
      redirect_to determine_redirect_path, alert: "カテゴリの更新に失敗しました"
    end
  end

  def edit
  end

  private

  def set_category_work_time
    @category_work_time = current_user.category_work_times.find(params[:id])
  end

  def category_work_time_params
    params.require(:category_work_time).permit(:name)
  end

  def from_income?
    params[:redirect_to_income].present?
  end

  def from_worktime?
    params[:redirect_to_worktime].present?
  end

  def determine_redirect_path
    return new_income_path if from_income?
    return new_work_time_path if from_worktime?
    root_path
  end

  def determine_render_template
    return "incomes/new" if from_income?
    return "work_times/new" if from_worktime?
    "homes/index"
  end

  def prepare_common_variables
    @work_time = current_user.work_times.new
    @income = current_user.incomes.new
    @category_work_times = CategoryWorkTime.where(user_id: nil)
      .or(CategoryWorkTime.where(user_id: current_user.id)).order(:id)
    @category_incomes = CategoryIncome.where(user_id: nil)
      .or(CategoryIncome.where(user_id: current_user.id)).order(:id)
  end
end
