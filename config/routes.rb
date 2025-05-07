Rails.application.routes.draw do
  root to: 'homes#index'
  devise_for :users

  resources :homes, only: [:index]
  resources :incomes

  delete 'category_incomes/delete_selected', to: 'category_incomes#delete_selected', as: 'delete_selected_category_incomes'
  patch  'category_incomes/update_selected', to: 'category_incomes#update_selected', as: 'update_selected_category_incomes'
  patch  'category_work_times/update_selected', to: 'category_work_times#update_selected', as: 'update_selected_category_work_times'
  delete 'category_work_times/delete_selected', to: 'category_work_times#delete_selected', as: 'delete_selected_category_work_times'
  resources :category_work_times, only: [:create, :destroy, :edit, :update]
  resources :category_incomes, only: [:create, :destroy, :edit, :update]
  resources :work_times, only: [:new, :create, :edit, :update, :destroy]
end
