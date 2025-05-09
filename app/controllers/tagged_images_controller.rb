class TaggedImagesController < ApplicationController
    before_action :set_expense
    before_action :set_tagged_image, only: [:edit, :update]
  
    def edit
    end
  
    def update
      if @tagged_image.update(tagged_image_params)
        redirect_to expense_path(@expense), notice: "画像を更新しました"
      else
        render :edit, alert: "更新に失敗しました"
      end
    end
  
    private
  
    def set_expense
      @expense = current_user.expenses.find(params[:expense_id])
    end
  
    def set_tagged_image
      @tagged_image = @expense.tagged_images.find(params[:id])
    end
  
    def tagged_image_params
      params.require(:tagged_image).permit(:image, :tag_list)
    end
  end
  
