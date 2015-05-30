Myflix::Application.routes.draw do
  root to: "pages#front"

  get 'home', to: "videos#index"
  get 'register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'
  get 'ui(/:action)', controller: 'ui'

  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy]

  resources :videos, only: [:show, :index] do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :queue_items, only: [:create, :destroy]
  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]
end
