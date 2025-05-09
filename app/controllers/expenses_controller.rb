class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update, :destroy]

  def new
    @expense = current_user.expenses.new
    @category_expense = current_user.category_expenses.build

    @category_expenses = CategoryExpense.where(user_id: nil)
      .or(CategoryExpense.where(user_id: current_user.id))
      .order(:id)

    @expense.tagged_images.build  # 画像とタグをつける場合
  end

  def create
    @expense = current_user.expenses.new(expense_params)
  
    # タグの自動付与
    category_tag = CategoryExpense.find_by(id: @expense.category_expense_id)&.name
    month_tag = "#{@expense.date.month}月" if @expense.date
    @expense.tagged_images.each do |image|
      image.tag_list.add(month_tag) if month_tag.present? && !image.tag_list.include?(month_tag)
      image.tag_list.add(category_tag) if category_tag.present? && !image.tag_list.include?(category_tag)
    end
  
    if @expense.save
      redirect_to root_path, notice: "支出を登録しました"
    else
      @category_expense = current_user.category_expenses.build
      @category_expenses = CategoryExpense.where(user_id: nil)
        .or(CategoryExpense.where(user_id: current_user.id)).order(:id)
      @expense.tagged_images.build if @expense.tagged_images.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category_expenses = CategoryExpense.where(user_id: nil)
      .or(CategoryExpense.where(user_id: current_user.id))
      .order(:id)

    @expense.tagged_images.build if @expense.tagged_images.empty?
  end

  def update
    if @expense.update(expense_params)
      redirect_to root_path, notice: "支出を更新しました"
    else
      @category_expenses = CategoryExpense.where(user_id: nil)
        .or(CategoryExpense.where(user_id: current_user.id))
        .order(:id)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to root_path, notice: "支出を削除しました"
  end

  private

  def expense_params
    params.require(:expense).permit(
      :date, :amount, :category_expense_id, :memo,
      tagged_images_attributes: [:id, :image, :tag_list, :_destroy]
    )
  end

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end
end