Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  devise_for :users

  resources :roles

  resources :tasks do 
    member do
      get :assign_task
      get :dis_assign_task
    end
    resources :comments
  end

  resources :teams do
    member do
      post :add_user
      get :remove_user
    end
  end

  resources :projects do
    resources :tasks do
    end
    member do
      post :add_user
      get :remove_user
    end
  end

  resources :users do
    member do
      get :torn_off_email
    end
  end

  root to: "home#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end