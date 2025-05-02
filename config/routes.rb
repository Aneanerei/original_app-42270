Rails.application.routes.draw do
  root to: 'homes#index'
  devise_for :users
  resources :homes
  resources :incomes
  resources :category_incomes, only: [:new, :create, :index]
  resources :work_times, only: [:new, :create]
end
