DocShare::Application.routes.draw do


  root :to => 'home#index'

  get "home/index"

  get "signup" => "users#new", :as => "signup"
  get "signin" => "sessions#new", :as => "signin"
  get "signout" => "sessions#destroy", :as => "signout"

  resources :users, :except => [:index] do
    member do
      get :activate
      get :password_edit
      put :password_update
    end
  end
  resources :sessions, :only => [:new, :create, :destroy]
  resources :reset_passwords, :only => [:new, :create, :edit, :update]

  resources :messages, :only => [:index, :new, :create] do
    collection do
      get :sent
      get :notifications
    end
  end




  if Rails.env.development?
    mount UserMailer::Preview => 'user_mailer_view'
  end

end

