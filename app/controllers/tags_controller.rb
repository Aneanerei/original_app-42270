class TagsController < ApplicationController
  def rename
    tag = ActsAsTaggableOn::Tag.find(params[:id])
    new_name = normalize(params[:new_name])

    if tag.name == new_name
      render json: { message: "変更なし" }
    elsif ActsAsTaggableOn::Tag.exists?(name: new_name)
      render json: { error: "すでに存在するタグです" }, status: :unprocessable_entity
    else
      tag.update!(name: new_name)
      render json: { success: true }
    end
  end

  def destroy
    tag = ActsAsTaggableOn::Tag.find_by(id: params[:id])
    if tag
      tag.destroy
      render json: { success: true }
    else
      render json: { error: "タグが見つかりません" }, status: :not_found
    end
  end

  private

  # 全角英数字記号を半角に変換するメソッド
  def normalize(str)
    str.to_s.tr('ａ-ｚＡ-Ｚ０-９！＠＃＄％＆（）ー－＝＋：；？’”“［］｛｝＜＞／＼', 
                'a-zA-Z0-9!@#$%&()-=+:;?\'"\"[]{}<>/\\')
  end
end
