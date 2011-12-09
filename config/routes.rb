DocShare::Application.routes.draw do

  root :to => 'home#index'

  #user signup signin signout, user edit profile
  resources :users, :except => [:index] do
    member do
      get :activate
      get :password_edit
      put :password_update
    end
  end
  resources :sessions, :only => [:new, :create]
  resources :reset_passwords, :only => [:new, :create, :edit, :update]
  get "signup" => "users#new", :as => "signup"
  get "signin" => "sessions#new", :as => "signin"
  get "signout" => "sessions#destroy", :as => "signout"
  get "account" => "users#show", :as => :profile
  get "account/edit" => "users#edit", :as => :edit_profile
  get "account/password/edit" => "users#password_edit", :as => :edit_password


  #message
  resources :messages, :only => [:index, :new, :create, :show, :destroy] do
    collection do
      get :sent
      get :notifications
    end
    member do
      put :reply
    end
  end


  #
  resources :repositories, :only => [:index]



  #account namespace
  namespace :account do
    root :to => "main#dashboard"
    get "dashboard" => "main#dashboard"
    get "notifications_center" => "main#notifications_center", :as => :notifications_center
    resources :repositories, :except => [:show] do
      resources :repo_files, :only => [:index, :create, :destroy] do
        collection do
          get :manage
          post :exist
        end
      end
    end
  end
  get "dashboard" => "account/main#dashboard", :as => :dashboard



  scope ":user" do
    root :to => "users#user_page", :as => :user_page

    get "repositories" => "repositories#public_repositories", :as => :user_public_repositories

    get "following" => "users#following", :as => :user_following  #following users and watching repositories

    get "followers" => "users#followers", :as => :user_followers

    match "reverse_follow" => "users#reverse_follow", :as => :user_reverse_follow, :via => :put

    scope ":repository" do
      root :to => "repositories#tree", :as => :user_repository

      get "watchers" => "repositories#watchers", :as => :user_repository_watchers

      match "reverse_watch" => "repositories#reverse_watch", :as => :user_repository_reverse_watch, :via => :put

      get "forks" => "repositories#forks", :as => :user_repository_forks

      match "fork" => "repositories#fork", :as => :user_repository_fork, :via => :put

      get "admin" => "repositories#admin", :as => :admin_user_repository

      match "tree(/:path)" => "repositories#tree", :as => :tree_user_repository

      match "blob/:path" => "repositories#blob", :as => :blob_user_repository

      resources :issues
    end
  end


  if Rails.env.development?
    mount UserMailer::Preview => 'user_mailer_view'
  end

end

#== Route Map
# Generated on 08 Dec 2011 20:40
#
#                repo_files_create GET    /repo_files/create(.:format)                                {:controller=>"repo_files", :action=>"create"}
#                   main_dashboard GET    /main/dashboard(.:format)                                   {:controller=>"main", :action=>"dashboard"}
#        main_notifications_center GET    /main/notifications_center(.:format)                        {:controller=>"main", :action=>"notifications_center"}
#                             root        /                                                           {:controller=>"home", :action=>"index"}
#                    activate_user GET    /users/:id/activate(.:format)                               {:action=>"activate", :controller=>"users"}
#               password_edit_user GET    /users/:id/password_edit(.:format)                          {:action=>"password_edit", :controller=>"users"}
#             password_update_user PUT    /users/:id/password_update(.:format)                        {:action=>"password_update", :controller=>"users"}
#                            users POST   /users(.:format)                                            {:action=>"create", :controller=>"users"}
#                         new_user GET    /users/new(.:format)                                        {:action=>"new", :controller=>"users"}
#                        edit_user GET    /users/:id/edit(.:format)                                   {:action=>"edit", :controller=>"users"}
#                             user GET    /users/:id(.:format)                                        {:action=>"show", :controller=>"users"}
#                                  PUT    /users/:id(.:format)                                        {:action=>"update", :controller=>"users"}
#                                  DELETE /users/:id(.:format)                                        {:action=>"destroy", :controller=>"users"}
#                         sessions POST   /sessions(.:format)                                         {:action=>"create", :controller=>"sessions"}
#                      new_session GET    /sessions/new(.:format)                                     {:action=>"new", :controller=>"sessions"}
#                  reset_passwords POST   /reset_passwords(.:format)                                  {:action=>"create", :controller=>"reset_passwords"}
#               new_reset_password GET    /reset_passwords/new(.:format)                              {:action=>"new", :controller=>"reset_passwords"}
#              edit_reset_password GET    /reset_passwords/:id/edit(.:format)                         {:action=>"edit", :controller=>"reset_passwords"}
#                   reset_password PUT    /reset_passwords/:id(.:format)                              {:action=>"update", :controller=>"reset_passwords"}
#                           signup GET    /signup(.:format)                                           {:action=>"new", :controller=>"users"}
#                           signin GET    /signin(.:format)                                           {:action=>"new", :controller=>"sessions"}
#                          signout GET    /signout(.:format)                                          {:action=>"destroy", :controller=>"sessions"}
#                          profile GET    /account(.:format)                                          {:action=>"show", :controller=>"users"}
#                     edit_profile GET    /account/edit(.:format)                                     {:controller=>"users", :action=>"edit"}
#                    edit_password GET    /account/password/edit(.:format)                            {:controller=>"users", :action=>"password_edit"}
#                    sent_messages GET    /messages/sent(.:format)                                    {:action=>"sent", :controller=>"messages"}
#           notifications_messages GET    /messages/notifications(.:format)                           {:action=>"notifications", :controller=>"messages"}
#                    reply_message PUT    /messages/:id/reply(.:format)                               {:action=>"reply", :controller=>"messages"}
#                         messages GET    /messages(.:format)                                         {:action=>"index", :controller=>"messages"}
#                                  POST   /messages(.:format)                                         {:action=>"create", :controller=>"messages"}
#                      new_message GET    /messages/new(.:format)                                     {:action=>"new", :controller=>"messages"}
#                          message GET    /messages/:id(.:format)                                     {:action=>"show", :controller=>"messages"}
#                                  DELETE /messages/:id(.:format)                                     {:action=>"destroy", :controller=>"messages"}
#         add_repo_file_repository GET    /repositories/:id/add_repo_file(.:format)                   {:action=>"add_repo_file", :controller=>"repositories"}
#                     repositories GET    /repositories(.:format)                                     {:action=>"index", :controller=>"repositories"}
#                                  POST   /repositories(.:format)                                     {:action=>"create", :controller=>"repositories"}
#                   new_repository GET    /repositories/new(.:format)                                 {:action=>"new", :controller=>"repositories"}
#                  edit_repository GET    /repositories/:id/edit(.:format)                            {:action=>"edit", :controller=>"repositories"}
#                       repository PUT    /repositories/:id(.:format)                                 {:action=>"update", :controller=>"repositories"}
#                     account_root        /account(.:format)                                          {:controller=>"account/main", :action=>"dashboard"}
#                account_dashboard GET    /account/dashboard(.:format)                                {:action=>"dashboard", :controller=>"account/main"}
#     account_notifications_center GET    /account/notifications_center(.:format)                     {:action=>"notifications_center", :controller=>"account/main"}
#    account_repository_repo_files POST   /account/repository/:repository_id/repo_files(.:format)     {:action=>"create", :controller=>"account/repo_files"}
# new_account_repository_repo_file GET    /account/repository/:repository_id/repo_files/new(.:format) {:action=>"new", :controller=>"account/repo_files"}
#          edit_account_repository GET    /account/repository/:id/edit(.:format)                      {:action=>"edit", :controller=>"account/repository"}
#                        dashboard GET    /dashboard(.:format)                                        {:action=>"dashboard", :controller=>"account/main"}
#        user_private_repositories GET    /account/repositories(.:format)                             {:controller=>"repositories", :action=>"private_repositories"}
#                        user_page        /:user(.:format)                                            {:controller=>"users", :action=>"user_page"}
#                   user_following GET    /:user/following(.:format)                                  {:action=>"following", :controller=>"users"}
#                   user_followers GET    /:user/followers(.:format)                                  {:action=>"followers", :controller=>"users"}
#              user_reverse_follow PUT    /:user/reverse_follow(.:format)                             {:action=>"reverse_follow", :controller=>"users"}
#         user_public_repositories GET    /:user/repositories(.:format)                               {:action=>"public_repositories", :controller=>"repositories"}
#                  user_repository        /:user/:repository(.:format)                                {:controller=>"repositories", :action=>"show"}
#         user_repository_watchers GET    /:user/:repository/watchers(.:format)                       {:action=>"watchers", :controller=>"repositories"}
#    user_repository_reverse_watch PUT    /:user/:repository/reverse_watch(.:format)                  {:action=>"reverse_watch", :controller=>"repositories"}
#            user_repository_forks GET    /:user/:repository/forks(.:format)                          {:action=>"forks", :controller=>"repositories"}
#             user_repository_fork PUT    /:user/:repository/fork(.:format)                           {:action=>"fork", :controller=>"repositories"}
#                             tree GET    /:user/:repository/tree(.:format)                           {:action=>"show", :controller=>"repositories"}
#                           issues GET    /:user/:repository/issues(.:format)                         {:action=>"index", :controller=>"issues"}
#                                  POST   /:user/:repository/issues(.:format)                         {:action=>"create", :controller=>"issues"}
#                        new_issue GET    /:user/:repository/issues/new(.:format)                     {:action=>"new", :controller=>"issues"}
#                       edit_issue GET    /:user/:repository/issues/:id/edit(.:format)                {:action=>"edit", :controller=>"issues"}
#                            issue GET    /:user/:repository/issues/:id(.:format)                     {:action=>"show", :controller=>"issues"}
#                                  PUT    /:user/:repository/issues/:id(.:format)                     {:action=>"update", :controller=>"issues"}
#                                  DELETE /:user/:repository/issues/:id(.:format)                     {:action=>"destroy", :controller=>"issues"}
#                                         /user_mailer_view                                           {:action=>"user_mailer_view", :to=>UserMailer::Preview}
#                             page        /pages/*id                                                  {:controller=>"high_voltage/pages", :action=>"show"}

