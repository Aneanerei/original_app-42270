class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update, :destroy]

  def new
    @expense = current_user.expenses.new
    prepare_form_data
    ensure_tagged_images
  end

  def create
    @expense = current_user.expenses.new(expense_params)
    apply_auto_tags(@expense)

    if @expense.save
      redirect_to root_path, notice: "支出を登録しました"
    else
      prepare_form_data
      ensure_tagged_images
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    prepare_form_data
    ensure_tagged_images
  end

 def update
  if @expense.update(expense_params)
    @expense.tagged_images.each do |image|
      next if image.marked_for_destruction?

      submitted_attrs = expense_params[:tagged_images_attributes]&.values&.find { |h| h[:id].to_s == image.id.to_s }
      next unless submitted_attrs

      new_tags = submitted_attrs[:tag_list].to_s.split(",").map(&:strip).reject(&:blank?)
      image.tag_list = new_tags
      image.save!
    end

    redirect_to root_path, notice: "支出を更新しました"
  else
    prepare_form_data
    ensure_tagged_images
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

  def prepare_form_data
    @category_expense = current_user.category_expenses.build
    @category_expenses = CategoryExpense.where(user_id: nil)
      .or(CategoryExpense.where(user_id: current_user.id)).order(:id)
  end

  def ensure_tagged_images
    @expense.tagged_images.build if @expense.tagged_images.empty?
  end

  def expense_params
    params.require(:expense).permit(
      :date, :amount, :memo, :category_expense_id,
      tagged_images_attributes: [:id, :image, :tag_list, :removed_auto_tags, :_destroy]
    )
  end

  def apply_auto_tags(expense)
    return unless expense.tagged_images.present?

    category_tag = CategoryExpense.find_by(id: expense.category_expense_id)&.name
    month_tag = "#{expense.date.month}月" if expense.date

    expense.tagged_images.each do |image|
      next unless image.image.attached?

      removed = (image.removed_auto_tags || "").split(",").map(&:strip)

      if newly_uploaded?(image.image.attachment)
        image.tag_list.add(month_tag) if month_tag.present? && !removed.include?(month_tag)
        image.tag_list.add(category_tag) if category_tag.present? && !removed.include?(category_tag)
      end
    end
  end

  def newly_uploaded?(attachment)
    attachment.created_at.present? && attachment.created_at >= 10.seconds.ago
  end
end
