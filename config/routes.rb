# frozen_string_literal: true
Rails.application.routes.draw do
  root 'inverters#index'
  resources :inverters, only: [:index, :new, :edit, :create, :update, :destroy] do
    resources :readings, only: [:index], controller: :inverter_readings
  end
end
