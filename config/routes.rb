Rails.application.routes.draw do
  # ルートページ（カレンダーなど）
  root to: 'homes#index'
  devise_for :users
  resources :homes, only: [:index]

  # 収入関連
  resources :incomes

  # 支出・画像・タグ付き
  resources :expenses do
    resources :tagged_images, only: [:edit, :update]
  end

  # アルバム（画像の閲覧・検索）
  resources :albums, only: [:index]
  get 'albums/tag/:tag', to: 'albums#index', as: :tagged_album

  # タグ操作（rename: PATCH /tags/rename, destroy: DELETE /tags/:id）
  resources :tags, only: [] do
    collection do
      patch :rename  # タグ名の変更
    end
    member do
      delete :destroy  # タグ削除
    end
  end

  # 支出カテゴリ操作（選択したものの一括削除・更新）
  delete 'category_expenses/delete_selected', to: 'category_expenses#delete_selected', as: 'delete_selected_category_expenses'
  patch  'category_expenses/update_selected', to: 'category_expenses#update_selected', as: 'update_selected_category_expenses'
  resources :category_expenses, only: [:create, :destroy, :edit, :update]

  # 収入カテゴリ操作
  delete 'category_incomes/delete_selected', to: 'category_incomes#delete_selected', as: 'delete_selected_category_incomes'
  patch  'category_incomes/update_selected', to: 'category_incomes#update_selected', as: 'update_selected_category_incomes'
  resources :category_incomes, only: [:create, :destroy, :edit, :update]

  # 労働カテゴリ操作
  delete 'category_work_times/delete_selected', to: 'category_work_times#delete_selected', as: 'delete_selected_category_work_times'
  patch  'category_work_times/update_selected', to: 'category_work_times#update_selected', as: 'update_selected_category_work_times'
  resources :category_work_times, only: [:create, :destroy, :edit, :update]

  # 労働時間入力・編集
  resources :work_times, only: [:new, :create, :edit, :update, :destroy]
  
  # 労働日報
  resources :work_reports, only: [:index]
  
  # 目標メーター設定
  resources :monthly_goals, only: [:create]

  resources :analyses, only: [:index]

end
