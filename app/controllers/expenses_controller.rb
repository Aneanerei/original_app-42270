class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update, :destroy]

  def new
    @expense = current_user.expenses.new
    @category_expense = current_user.category_expenses.build
    @category_expenses = CategoryExpense.where(user_id: nil)
      .or(CategoryExpense.where(user_id: current_user.id))
      .order(:id)
    @expense.tagged_images.build
  end

  def create
    @expense = current_user.expenses.new(expense_params)
    apply_auto_tags(@expense)

    if @expense.save
      redirect_to root_path, notice: "支出を登録しました"
    else
      prepare_form_for(:new)
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
    # タグ再付与は新規画像が含まれているときのみ
    if params[:expense][:tagged_images_attributes].present?
      category_tag = CategoryExpense.find_by(id: expense_params[:category_expense_id])&.name
      month_tag = "#{expense_params[:date].to_date.month}月" rescue nil

      if category_tag || month_tag
        @expense.tagged_images.each do |image|
          next unless image.image.attached?

          if image.image.attachment&.created_at.present? && image.image.attachment.created_at >= 5.seconds.ago
            image.tag_list.add(month_tag) if month_tag.present? && !image.tag_list.include?(month_tag)
            image.tag_list.add(category_tag) if category_tag.present? && !image.tag_list.include?(category_tag)
          end
        end
      end
    end

    if @expense.update(expense_params)
      redirect_to root_path, notice: "支出を更新しました"
    else
      @category_expenses = CategoryExpense.where(user_id: nil)
        .or(CategoryExpense.where(user_id: current_user.id)).order(:id)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to root_path, notice: "支出を削除しました"
  end

  private

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(
      :date, :amount, :category_expense_id, :memo,
      tagged_images_attributes: [:id, :image, :tag_list, :_destroy]
    )
  end

  def apply_auto_tags(expense)
    return unless expense.tagged_images.present?

    category_tag = CategoryExpense.find_by(id: expense.category_expense_id)&.name
    month_tag = "#{expense.date.month}月" if expense.date

    expense.tagged_images.each do |image|
      next unless image.image.attached?

      if image.image.attachment&.created_at.present? && image.image.attachment.created_at >= 5.seconds.ago
        image.tag_list.add(month_tag) if month_tag.present? && !image.tag_list.include?(month_tag)
        image.tag_list.add(category_tag) if category_tag.present? && !image.tag_list.include?(category_tag)
      end
    end
  end

  def prepare_form_for(action)
    @category_expense = current_user.category_expenses.build
    @category_expenses = CategoryExpense.where(user_id: nil)
      .or(CategoryExpense.where(user_id: current_user.id)).order(:id)
    @expense.tagged_images.build if @expense.tagged_images.empty?
  end
end
