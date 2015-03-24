Rails.application.routes.draw do
  devise_for :users
  resources :links

  root to: 'visitors#index'
end
