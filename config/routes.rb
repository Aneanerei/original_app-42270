Rails.application.routes.draw do
  root to: 'homes#index'
  devise_for :users
  resources :homes, only: [:index]
  resources :incomes
  resources :category_work_times, only: [:create, :destroy]
  resources :category_incomes, only: [:create, :destroy]
  resources :work_times, only: [:new, :create, :edit, :update, :destroy]
end
