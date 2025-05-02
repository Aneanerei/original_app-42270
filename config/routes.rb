Rails.application.routes.draw do
  root to: 'homes#index'
  devise_for :users
  resources :homes, only: [:index]
  resources :incomes, only: [:new, :create]
  resources :category_incomes, only: [:new, :create, :index]
  resources :work_times, only: [:new, :create, :destroy]
end
