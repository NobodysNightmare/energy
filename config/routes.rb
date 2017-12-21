# frozen_string_literal: true
Rails.application.routes.draw do
  root 'meters#index'
  resources :meters, only: [:index, :new, :edit, :create, :update, :destroy] do
    resources :readings, only: [:index], controller: :readings
  end

  namespace :api do
    resources :meters, param: :serial, only: [] do
      resources :readings, only: [:create], controller: :readings
    end
  end

  get '/login', to: 'sessions#new'
  match '/auth/:provider/callback', to: 'sessions#create', via: [:post, :get]
  get '/logout', to: 'sessions#destroy'
  get '/no_session', to: 'sessions#missing'
  get '/no_privileges', to: 'sessions#insufficient'
end
