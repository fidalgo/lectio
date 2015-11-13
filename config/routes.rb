Rails.application.routes.draw do
  devise_for :users
  resources :links do
    member do
      get 'read'
    end
    collection do
      get 'tags'
    end
  end

  # root to: 'visitors#index'
  root to: 'links#index'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: '/auth'
    end
  end

end
