Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/auth'
  devise_for :users
  resources :links
  
  root to: 'visitors#index'
end
