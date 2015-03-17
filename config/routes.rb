Rails.application.routes.draw do
  resources :links

  root to: 'visitors#index'
end
