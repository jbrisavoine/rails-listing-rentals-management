Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'listings#index'

  resources :listings, only: %i[index show create update destroy]

  resources :missions, only: %i[index create update destroy]
end
