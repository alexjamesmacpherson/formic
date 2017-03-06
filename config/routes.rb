Rails.application.routes.draw do
  root 'static#home'

  get     '/about'    =>  'static#about'
  get     '/features' =>  'static#features'
  get     '/contact'  =>  'static#contact'
  get     '/login'    =>  'sessions#new'
  post    '/login'    =>  'sessions#create'
  delete  '/logout'   =>  'sessions#destroy'

  # Schools added/deleted programmatically rather than through system - hence can only be performed by system admin.
  resources :schools, only: [:show, :edit, :update]
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :notifications, only: [:update]
end
