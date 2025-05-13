class CategoryExpensesController < ApplicationController
  before_action :set_category_expense, only: [:edit, :update, :destroy]

  def create
    @category_expense = current_user.category_expenses.build(category_expense_params)

    if @category_expense.save
      redirect_to new_expense_path, notice: "カテゴリを追加しました"
    else
      @expense = current_user.expenses.new
      @category_expenses = CategoryExpense.where(user_id: nil)
                                .or(CategoryExpense.where(user_id: current_user.id))
                                .order(:id)
       flash.now[:alert] = "カテゴリの追加に失敗しました"
      render 'expenses/new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category_expense.update(category_expense_params)
      redirect_to new_expense_path, notice: "カテゴリを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category_expense.destroy
      redirect_to new_expense_path, notice: "カテゴリを削除しました"
    else
      redirect_to new_expense_path, alert: @category_expense.errors.full_messages.to_sentence
    end
  end

  # ✅ セレクト削除用
  def delete_selected
    category = current_user.category_expenses.find_by(id: params[:category_id])

    if category.nil?
      redirect_to new_expense_path, alert: "カテゴリが見つかりません"
      return
    end

    if category.expenses.exists?
      redirect_to new_expense_path, alert: "このカテゴリは支出が登録されているため削除できません"
      return
    end

    if category.destroy
      redirect_to new_expense_path, notice: "カテゴリを削除しました"
    else
      redirect_to new_expense_path, alert: "削除に失敗しました"
    end
  end

  # ✅ セレクト編集用
  def update_selected
    category = current_user.category_expenses.find_by(id: params[:category_id])

    if category.present? && category.update(name: params[:new_name])
      redirect_to new_expense_path, notice: "カテゴリを更新しました"
    else
      redirect_to new_expense_path, alert: "カテゴリの更新に失敗しました"
    end
  end

  private

  def set_category_expense
    @category_expense = current_user.category_expenses.find(params[:id])
  end

  def category_expense_params
    params.require(:category_expense).permit(:name)
  end
end
