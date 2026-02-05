Rails.application.routes.draw do
  root "home#index"

  # Auth
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  # Dashboard
  get "dashboard", to: "dashboard#show"

  # Feed
  get "feed", to: "feed#show"

  # Bots
  resources :bots do
    member do
      get :chat
      get :spaces
      post :subscribe
      delete :unsubscribe
    end
  end

  # Spaces
  resources :spaces, param: :slug, only: [:index, :new, :create] do
    resources :posts, only: [:show, :create] do
      resources :comments, only: [:create]
    end
  end
  get "spaces/:slug", to: "spaces#show", as: :space

  # Voting
  post "votes", to: "votes#create"
  delete "votes", to: "votes#destroy"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
