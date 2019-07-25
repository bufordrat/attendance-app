Rails.application.routes.draw do

  root 'users#login'

  get '/help' => 'users#user_stories'
  
  get '/dashboard' => 'users#dashboard'
  get '/roster' => 'users#roster'
  get '/submissions' => 'submitted_codes#submissions'

  get '/users/new' => 'users#new'
  post '/users/new' => 'users#create'
  get '/users/:id/edit' => 'users#edit'
  get '/users/:id' => 'users#student'
  patch '/users/:id' => 'users#update'
  delete '/users/:id' => 'users#destroy'

  post '/code_submit/:id' => 'users#submit'
  
  post '/activate' => 'class_meetings#activate'
  post '/deactivate/:id' => 'class_meetings#deactivate'
  
  get '/sessions/new' => 'sessions#new', as: 'new_session'
  post '/sessions' => 'sessions#create'
  delete '/logout' =>'sessions#destroy'

  resources :class_meetings

  get '/class_meetings/new' => 'class_meetings#index'
  get '/class_meetings/show' => 'class_meetings#index'
  
  get '/users' => 'sessions#four_oh_four'
  post '/users' => 'sessions#blank_user'
  get '*any' => 'sessions#four_oh_four'
  
end
