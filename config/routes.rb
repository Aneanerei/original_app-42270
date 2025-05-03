Rails.application.routes.draw do
  root to: 'homes#index'
  devise_for :users
  resources :homes, only: [:index]
  resources :incomes
  resources :category_incomes, only: [:new, :create,]
  resources :work_times
end
