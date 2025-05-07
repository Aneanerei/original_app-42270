class CategoryIncomesController < ApplicationController 
  before_action :set_category_income, only: [:edit, :update, :destroy]

  def create
    @category_income = current_user.category_incomes.build(category_income_params)

    if @category_income.save
      redirect_to new_income_path, alert: "カテゴリを追加しました"
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

  def edit
  end

  def update
    if @category_income.update(category_income_params)
      redirect_to new_income_path, alert: 'カテゴリを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category_income.destroy
      redirect_to new_income_path, alert: "カテゴリを削除しました"
    else
      redirect_to new_income_path, alert: @category_income.errors.full_messages.to_sentence
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
      redirect_to new_income_path, alert: "カテゴリを削除しました"
    else
      redirect_to new_income_path, alert: "カテゴリの削除に失敗しました"
    end
  end
  

  # プルダウン編集機能
  def update_selected
    category = current_user.category_incomes.find_by(id: params[:category_id])

    if category.present? && category.update(name: params[:new_name])
      redirect_to new_income_path, alert: "カテゴリを更新しました"
    else
      redirect_to new_income_path, alert: "カテゴリの更新に失敗しました"
    end
  end

  private

  def set_category_income
    @category_income = current_user.category_incomes.find(params[:id])
  end

  def category_income_params
    params.require(:category_income).permit(:name)
  end
end
