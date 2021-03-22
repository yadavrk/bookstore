Rails.application.routes.draw do
  resources :books
  resources :authors
  get 'home/index'
  root to: 'authors#index'
end
