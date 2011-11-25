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

  resources :messages, :only => [:index, :new, :create, :show, :destroy] do
    collection do
      get :sent
      get :notifications
    end
    member do
      put :reply
    end
  end




  if Rails.env.development?
    mount UserMailer::Preview => 'user_mailer_view'
  end

end

#== Route Map
# Generated on 25 Nov 2011 11:07
#
#             home_index GET    /home/index(.:format)                {:controller=>"home", :action=>"index"}
#                 signup GET    /signup(.:format)                    {:action=>"new", :controller=>"users"}
#                 signin GET    /signin(.:format)                    {:action=>"new", :controller=>"sessions"}
#                signout GET    /signout(.:format)                   {:action=>"destroy", :controller=>"sessions"}
#          activate_user GET    /users/:id/activate(.:format)        {:action=>"activate", :controller=>"users"}
#     password_edit_user GET    /users/:id/password_edit(.:format)   {:action=>"password_edit", :controller=>"users"}
#   password_update_user PUT    /users/:id/password_update(.:format) {:action=>"password_update", :controller=>"users"}
#                  users POST   /users(.:format)                     {:action=>"create", :controller=>"users"}
#               new_user GET    /users/new(.:format)                 {:action=>"new", :controller=>"users"}
#              edit_user GET    /users/:id/edit(.:format)            {:action=>"edit", :controller=>"users"}
#                   user GET    /users/:id(.:format)                 {:action=>"show", :controller=>"users"}
#                        PUT    /users/:id(.:format)                 {:action=>"update", :controller=>"users"}
#                        DELETE /users/:id(.:format)                 {:action=>"destroy", :controller=>"users"}
#               sessions POST   /sessions(.:format)                  {:action=>"create", :controller=>"sessions"}
#            new_session GET    /sessions/new(.:format)              {:action=>"new", :controller=>"sessions"}
#                session DELETE /sessions/:id(.:format)              {:action=>"destroy", :controller=>"sessions"}
#        reset_passwords POST   /reset_passwords(.:format)           {:action=>"create", :controller=>"reset_passwords"}
#     new_reset_password GET    /reset_passwords/new(.:format)       {:action=>"new", :controller=>"reset_passwords"}
#    edit_reset_password GET    /reset_passwords/:id/edit(.:format)  {:action=>"edit", :controller=>"reset_passwords"}
#         reset_password PUT    /reset_passwords/:id(.:format)       {:action=>"update", :controller=>"reset_passwords"}
#          sent_messages GET    /messages/sent(.:format)             {:action=>"sent", :controller=>"messages"}
# notifications_messages GET    /messages/notifications(.:format)    {:action=>"notifications", :controller=>"messages"}
#               messages GET    /messages(.:format)                  {:action=>"index", :controller=>"messages"}
#                        POST   /messages(.:format)                  {:action=>"create", :controller=>"messages"}
#            new_message GET    /messages/new(.:format)              {:action=>"new", :controller=>"messages"}
#                message DELETE /messages/:id(.:format)              {:action=>"destroy", :controller=>"messages"}
#                               /user_mailer_view                    {:action=>"user_mailer_view", :to=>UserMailer::Preview}
#                   page        /pages/*id                           {:controller=>"high_voltage/pages", :action=>"show"}

