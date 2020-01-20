# frozen_string_literal: true

Rails.application.routes.draw do
  # User Sessions Handling, Login, Logout
  resource :session, only: %i[new create destroy]

  resources :stories, only: %i[index create] do
    resources :passages, only: :show, format: :json
  end

  resources :messages, only: :index, format: :json

  resources :save_games, only: %i[index show update], format: :json do
    get :load
    get :active, on: :collection
  end

  resources :pages, only: :show

  mount AlexaHandler => '/whatif'
  root to: 'users#show'
end
