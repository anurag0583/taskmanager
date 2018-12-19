Rails.application.routes.draw do

  # match "/404", :to => "errors#not_found", :via => :all
  # match "/500", :to => "errors#internal_server_error", :via => :all

  resources :tests
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  devise_for :users

  resources :roles

  resources :tasks do 
    member do
      get :assign_task
      get :dis_assign_task
      post :update_status
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
  get "home/index_client"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end