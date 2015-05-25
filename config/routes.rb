Rails.application.routes.draw do
  devise_for :users
  resources :links

  root to: 'visitors#index'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: '/auth'
    end
  end
  
end
