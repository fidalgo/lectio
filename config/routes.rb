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

  root to: 'links#index'
end
