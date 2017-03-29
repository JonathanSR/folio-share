Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  get '/home', to: 'users#show'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

end
