Rails.application.routes.draw do
  root 'static#home'

  get '/about'    =>  'static#about'
  get '/features' =>  'static#features'
  get '/contact'  =>  'static#contact'

  resources :schools
  resources :users
end
