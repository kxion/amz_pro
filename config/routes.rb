Rails.application.routes.draw do

  root to: 'welcome#show'

  resources :welcome
  resources :users

  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  post "/sessions", to: "sessions#create"
  get '/auth/:provider/callback', to: 'sessions#update'

end
