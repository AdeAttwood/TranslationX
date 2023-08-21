# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'
  devise_for :users

  resources :projects, param: :project_id
  resources :projects, only: [] do
    resources :translations, only: %i[index create update], param: :translation_id
    resources :translation_uploads, only: %i[create]
  end
end
