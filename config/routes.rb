Rails.application.routes.draw do
  resources :packages, only: :index

  root 'packages#index'
end
