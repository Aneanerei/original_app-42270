class CategoryExpensesController < ApplicationController
  before_action :set_category_expense, only: [:edit, :update, :destroy]

  def create
    @category_expense = current_user.category_expenses.build(category_expense_params)

    if @category_expense.save
      redirect_to new_expense_path, alert: "カテゴリを追加しました"
    else
      @expense = current_user.expenses.new

      @category_expenses = CategoryExpense.where(user_id: nil)
        .or(CategoryExpense.where(user_id: current_user.id))
        .order(:id)

      render 'expenses/new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category_expense.update(category_expense_params)
      redirect_to new_expense_path, alert: "カテゴリを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category_expense.destroy
      redirect_to new_expense_path, alert: "カテゴリを削除しました"
    else
      redirect_to new_expense_path, alert: @category_expense.errors.full_messages.to_sentence
    end
  end

  # プルダウン削除機能
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
