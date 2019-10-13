# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }, defaults: { format: :json }

  resources :projects do
    resources :tasks
  end

  patch 'tasks/:id/complete', to: 'tasks#complete'
  patch 'tasks/:id/priority', to: 'tasks#update_priority'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
