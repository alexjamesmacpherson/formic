Rails.application.routes.draw do
  get 'users/index'

  get 'users/show'

  get 'users/new'

  get 'users/create'

  get 'users/edit'

  get 'users/update'

  get 'users/destroy'

  get 'schools/index'

  get 'schools/show'

  get 'schools/new'

  get 'schools/create'

  get 'schools/edit'

  get 'schools/update'

  root 'static#home'

  get '/about'    =>  'static#about'
  get '/features' =>  'static#features'
  get '/contact'  =>  'static#contact'

end
