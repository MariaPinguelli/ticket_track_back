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
  resources :users do
    member do
      post 'add_favorite/:event_id', to: 'users#add_favorite', as: :add_favorite
      delete 'remove_favorite/:event_id', to: 'users#remove_favorite', as: :remove_favorite
    end
  end
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :events
end
