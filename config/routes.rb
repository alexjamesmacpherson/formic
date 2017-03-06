Rails.application.routes.draw do
  root 'static#home'

  get     '/about'    =>  'static#about'
  get     '/features' =>  'static#features'
  get     '/contact'  =>  'static#contact'
  get     '/login'    =>  'sessions#new'
  post    '/login'    =>  'sessions#create'
  delete  '/logout'   =>  'sessions#destroy'
  post    '/readall'  =>  'notifications#readall'
  post    '/readchats'=>  'chats#readall'
  post    '/send'     =>  'chats#send_message'

  # Schools added/deleted programmatically rather than through system - hence can only be performed by system admin.
  resources :schools, only: [:show, :edit, :update]
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :notifications, only: [:update]
  resources :chats, only: [:update]
end
