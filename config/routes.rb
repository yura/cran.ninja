require 'sidekiq/web'

Rails.application.routes.draw do
  resources :packages, only: [:index, :show]

  root 'packages#index'

  mount Sidekiq::Web => '/sidekiq'
end
