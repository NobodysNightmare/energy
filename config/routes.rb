# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sites#index'

  resources :meters, only: %i[index new edit create update destroy] do
    resources :readings, only: %i[index new create update destroy]

    member do
      get 'timeline' => 'meters_timelines#index'
    end
  end

  resources :sites, only: %i[index new edit create update destroy] do
    resources :meters, only: %i[index new], controller: :meters

    member do
      get 'timeline' => 'sites_timelines#index'
    end
  end

  namespace :api do
    # Keeping up backwards compatibility with older API
    resources :inverters, param: :serial, only: [] do
      resources :readings, only: [:create], controller: :readings
    end

    resources :meters, param: :serial, only: [] do
      resources :readings, only: [:create], controller: :readings
    end

    get 'prometheus', to: 'prometheus#index'
  end

  get '/login', to: 'sessions#new'
  match '/auth/:provider/callback', to: 'sessions#create', via: %i[post get]
  get '/logout', to: 'sessions#destroy'
  get '/no_session', to: 'sessions#missing'
  get '/no_privileges', to: 'sessions#insufficient'
end
