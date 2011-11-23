DocShare::Application.routes.draw do

  root :to => 'home#index'

  get "home/index"

  get "signup" => "users#new", :as => "signup"
  get "signin" => "sessions#new", :as => "signin"
  get "signout" => "sessions#destroy", :as => "signout"

  resources :users do
    member do
      get :activate
    end
  end
  resources :sessions
  resources :passwords
  resources :reset_passwords


  if Rails.env.development?
    mount UserMailer::Preview => 'user_mailer_view'
  end

end

