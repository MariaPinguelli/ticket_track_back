Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post 'login', to: 'sessions#create'
  post '/events/:event_id/favorite', to: 'favorites#create'
  resources :favorites, only: [:index, :destroy]
  resources :users 
  get '/user', to: 'users#show'
  resources :events
  get '/events', to: 'events#show'
end
