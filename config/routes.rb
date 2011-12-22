DocShare::Application.routes.draw do

  root :to => 'home#index'

  #user signup signin signout, user edit profile
  resources :users, :except => [:index, :show] do
    collection do
      get :autocomplete_with_username
    end
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
  get "account/edit" => "users#edit", :as => :edit_profile
  get "account/password/edit" => "users#password_edit", :as => :edit_password


  #
  resources :users, :only => [:index]
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
    resources :messages, :only => [:index, :new, :create, :show, :destroy] do
      collection do
        get :sent
        get :notifications
      end
      member do
        put :reply
      end
    end
  end
  get "dashboard" => "account/main#dashboard", :as => :dashboard



  #admin namespace
  namespace :admin do
    root :to => "main#dashboard"
    get "dashboard" => "main#dashboard", :as => :dashboard
    resources :roles do
      get :export, :on => :collection
      get :delete, :on=> :member
    end
    resources :users do
      get :export, :on => :collection
      get :delete, :on=> :member
    end
    resources :messages do
      get :export, :on => :collection
      get :delete, :on=> :member
    end
    resources :categories do
      get :export, :on => :collection
      get :delete, :on=> :member
    end
    resources :repositories do
      get :export, :on => :collection
      get :delete, :on=> :member
    end
    resources :activities, :only => [:index, :show] do
      get :export, :on => :collection
    end
    resource :site_config, :only => [:show, :edit, :update] do
      post :reinitialize
    end
    resources :backups, :only => [] do
      collection do
        get :download
        delete :delete
        get :databases
        post :backup_database
      end
    end
  end




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

      match "tree(/:tree_path)" => "repositories#tree", :as => :tree_user_repository,
                                                        :constraints => { :blob_path => /.*/ }

      match "blob/:blob_path" => "repositories#blob", :as => :blob_user_repository,
                                                      :constraints => { :blob_path => /.*/ }

      resources :issues
    end
  end


  # mail preview
  if Rails.env.development?
    mount UserMailer::Preview => 'user_mailer_view'
  end

end

#== Route Map
# Generated on 19 Dec 2011 11:26
#
#     autocomplete_with_username_users GET    /users/autocomplete_with_username(.:format)                      {:action=>"autocomplete_with_username", :controller=>"users"}
#                        activate_user GET    /users/:id/activate(.:format)                                    {:action=>"activate", :controller=>"users"}
#                   password_edit_user GET    /users/:id/password_edit(.:format)                               {:action=>"password_edit", :controller=>"users"}
#                 password_update_user PUT    /users/:id/password_update(.:format)                             {:action=>"password_update", :controller=>"users"}
#                                users POST   /users(.:format)                                                 {:action=>"create", :controller=>"users"}
#                             new_user GET    /users/new(.:format)                                             {:action=>"new", :controller=>"users"}
#                            edit_user GET    /users/:id/edit(.:format)                                        {:action=>"edit", :controller=>"users"}
#                                 user GET    /users/:id(.:format)                                             {:action=>"show", :controller=>"users"}
#                                      PUT    /users/:id(.:format)                                             {:action=>"update", :controller=>"users"}
#                                      DELETE /users/:id(.:format)                                             {:action=>"destroy", :controller=>"users"}
#                             sessions POST   /sessions(.:format)                                              {:action=>"create", :controller=>"sessions"}
#                          new_session GET    /sessions/new(.:format)                                          {:action=>"new", :controller=>"sessions"}
#                      reset_passwords POST   /reset_passwords(.:format)                                       {:action=>"create", :controller=>"reset_passwords"}
#                   new_reset_password GET    /reset_passwords/new(.:format)                                   {:action=>"new", :controller=>"reset_passwords"}
#                  edit_reset_password GET    /reset_passwords/:id/edit(.:format)                              {:action=>"edit", :controller=>"reset_passwords"}
#                       reset_password PUT    /reset_passwords/:id(.:format)                                   {:action=>"update", :controller=>"reset_passwords"}
#                               signup GET    /signup(.:format)                                                {:action=>"new", :controller=>"users"}
#                               signin GET    /signin(.:format)                                                {:action=>"new", :controller=>"sessions"}
#                              signout GET    /signout(.:format)                                               {:action=>"destroy", :controller=>"sessions"}
#                              profile GET    /account(.:format)                                               {:action=>"show", :controller=>"users"}
#                         edit_profile GET    /account/edit(.:format)                                          {:controller=>"users", :action=>"edit"}
#                        edit_password GET    /account/password/edit(.:format)                                 {:controller=>"users", :action=>"password_edit"}
#                         repositories GET    /repositories(.:format)                                          {:action=>"index", :controller=>"repositories"}
#                         account_root        /account(.:format)                                               {:controller=>"account/main", :action=>"dashboard"}
#                    account_dashboard GET    /account/dashboard(.:format)                                     {:action=>"dashboard", :controller=>"account/main"}
#         account_notifications_center GET    /account/notifications_center(.:format)                          {:action=>"notifications_center", :controller=>"account/main"}
# manage_account_repository_repo_files GET    /account/repositories/:repository_id/repo_files/manage(.:format) {:action=>"manage", :controller=>"account/repo_files"}
#  exist_account_repository_repo_files POST   /account/repositories/:repository_id/repo_files/exist(.:format)  {:action=>"exist", :controller=>"account/repo_files"}
#        account_repository_repo_files GET    /account/repositories/:repository_id/repo_files(.:format)        {:action=>"index", :controller=>"account/repo_files"}
#                                      POST   /account/repositories/:repository_id/repo_files(.:format)        {:action=>"create", :controller=>"account/repo_files"}
#         account_repository_repo_file DELETE /account/repositories/:repository_id/repo_files/:id(.:format)    {:action=>"destroy", :controller=>"account/repo_files"}
#                 account_repositories GET    /account/repositories(.:format)                                  {:action=>"index", :controller=>"account/repositories"}
#                                      POST   /account/repositories(.:format)                                  {:action=>"create", :controller=>"account/repositories"}
#               new_account_repository GET    /account/repositories/new(.:format)                              {:action=>"new", :controller=>"account/repositories"}
#              edit_account_repository GET    /account/repositories/:id/edit(.:format)                         {:action=>"edit", :controller=>"account/repositories"}
#                   account_repository PUT    /account/repositories/:id(.:format)                              {:action=>"update", :controller=>"account/repositories"}
#                                      DELETE /account/repositories/:id(.:format)                              {:action=>"destroy", :controller=>"account/repositories"}
#                sent_account_messages GET    /account/messages/sent(.:format)                                 {:action=>"sent", :controller=>"account/messages"}
#       notifications_account_messages GET    /account/messages/notifications(.:format)                        {:action=>"notifications", :controller=>"account/messages"}
#                reply_account_message PUT    /account/messages/:id/reply(.:format)                            {:action=>"reply", :controller=>"account/messages"}
#                     account_messages GET    /account/messages(.:format)                                      {:action=>"index", :controller=>"account/messages"}
#                                      POST   /account/messages(.:format)                                      {:action=>"create", :controller=>"account/messages"}
#                  new_account_message GET    /account/messages/new(.:format)                                  {:action=>"new", :controller=>"account/messages"}
#                      account_message GET    /account/messages/:id(.:format)                                  {:action=>"show", :controller=>"account/messages"}
#                                      DELETE /account/messages/:id(.:format)                                  {:action=>"destroy", :controller=>"account/messages"}
#                            dashboard GET    /dashboard(.:format)                                             {:action=>"dashboard", :controller=>"account/main"}
#                           admin_root        /admin(.:format)                                                 {:controller=>"admin/main", :action=>"dashboard"}
#                      admin_dashboard GET    /admin/dashboard(.:format)                                       {:action=>"dashboard", :controller=>"admin/main"}
#                   export_admin_users GET    /admin/users/export(.:format)                                    {:action=>"export", :controller=>"admin/users"}
#                    delete_admin_user GET    /admin/users/:id/delete(.:format)                                {:action=>"delete", :controller=>"admin/users"}
#                          admin_users GET    /admin/users(.:format)                                           {:action=>"index", :controller=>"admin/users"}
#                                      POST   /admin/users(.:format)                                           {:action=>"create", :controller=>"admin/users"}
#                       new_admin_user GET    /admin/users/new(.:format)                                       {:action=>"new", :controller=>"admin/users"}
#                      edit_admin_user GET    /admin/users/:id/edit(.:format)                                  {:action=>"edit", :controller=>"admin/users"}
#                           admin_user GET    /admin/users/:id(.:format)                                       {:action=>"show", :controller=>"admin/users"}
#                                      PUT    /admin/users/:id(.:format)                                       {:action=>"update", :controller=>"admin/users"}
#                                      DELETE /admin/users/:id(.:format)                                       {:action=>"destroy", :controller=>"admin/users"}
#                   export_admin_roles GET    /admin/roles/export(.:format)                                    {:action=>"export", :controller=>"admin/roles"}
#                    delete_admin_role GET    /admin/roles/:id/delete(.:format)                                {:action=>"delete", :controller=>"admin/roles"}
#                          admin_roles GET    /admin/roles(.:format)                                           {:action=>"index", :controller=>"admin/roles"}
#                                      POST   /admin/roles(.:format)                                           {:action=>"create", :controller=>"admin/roles"}
#                       new_admin_role GET    /admin/roles/new(.:format)                                       {:action=>"new", :controller=>"admin/roles"}
#                      edit_admin_role GET    /admin/roles/:id/edit(.:format)                                  {:action=>"edit", :controller=>"admin/roles"}
#                           admin_role GET    /admin/roles/:id(.:format)                                       {:action=>"show", :controller=>"admin/roles"}
#                                      PUT    /admin/roles/:id(.:format)                                       {:action=>"update", :controller=>"admin/roles"}
#                                      DELETE /admin/roles/:id(.:format)                                       {:action=>"destroy", :controller=>"admin/roles"}
#              export_admin_categories GET    /admin/categories/export(.:format)                               {:action=>"export", :controller=>"admin/categories"}
#                delete_admin_category GET    /admin/categories/:id/delete(.:format)                           {:action=>"delete", :controller=>"admin/categories"}
#                     admin_categories GET    /admin/categories(.:format)                                      {:action=>"index", :controller=>"admin/categories"}
#                                      POST   /admin/categories(.:format)                                      {:action=>"create", :controller=>"admin/categories"}
#                   new_admin_category GET    /admin/categories/new(.:format)                                  {:action=>"new", :controller=>"admin/categories"}
#                  edit_admin_category GET    /admin/categories/:id/edit(.:format)                             {:action=>"edit", :controller=>"admin/categories"}
#                       admin_category GET    /admin/categories/:id(.:format)                                  {:action=>"show", :controller=>"admin/categories"}
#                                      PUT    /admin/categories/:id(.:format)                                  {:action=>"update", :controller=>"admin/categories"}
#                                      DELETE /admin/categories/:id(.:format)                                  {:action=>"destroy", :controller=>"admin/categories"}
#            export_admin_repositories GET    /admin/repositories/export(.:format)                             {:action=>"export", :controller=>"admin/repositories"}
#              delete_admin_repository GET    /admin/repositories/:id/delete(.:format)                         {:action=>"delete", :controller=>"admin/repositories"}
#                   admin_repositories GET    /admin/repositories(.:format)                                    {:action=>"index", :controller=>"admin/repositories"}
#                                      POST   /admin/repositories(.:format)                                    {:action=>"create", :controller=>"admin/repositories"}
#                 new_admin_repository GET    /admin/repositories/new(.:format)                                {:action=>"new", :controller=>"admin/repositories"}
#                edit_admin_repository GET    /admin/repositories/:id/edit(.:format)                           {:action=>"edit", :controller=>"admin/repositories"}
#                     admin_repository GET    /admin/repositories/:id(.:format)                                {:action=>"show", :controller=>"admin/repositories"}
#                                      PUT    /admin/repositories/:id(.:format)                                {:action=>"update", :controller=>"admin/repositories"}
#                                      DELETE /admin/repositories/:id(.:format)                                {:action=>"destroy", :controller=>"admin/repositories"}
#                export_admin_messages GET    /admin/messages/export(.:format)                                 {:action=>"export", :controller=>"admin/messages"}
#                 delete_admin_message GET    /admin/messages/:id/delete(.:format)                             {:action=>"delete", :controller=>"admin/messages"}
#                       admin_messages GET    /admin/messages(.:format)                                        {:action=>"index", :controller=>"admin/messages"}
#                                      POST   /admin/messages(.:format)                                        {:action=>"create", :controller=>"admin/messages"}
#                    new_admin_message GET    /admin/messages/new(.:format)                                    {:action=>"new", :controller=>"admin/messages"}
#                   edit_admin_message GET    /admin/messages/:id/edit(.:format)                               {:action=>"edit", :controller=>"admin/messages"}
#                        admin_message GET    /admin/messages/:id(.:format)                                    {:action=>"show", :controller=>"admin/messages"}
#                                      PUT    /admin/messages/:id(.:format)                                    {:action=>"update", :controller=>"admin/messages"}
#                                      DELETE /admin/messages/:id(.:format)                                    {:action=>"destroy", :controller=>"admin/messages"}
#              export_admin_activities GET    /admin/activities/export(.:format)                               {:action=>"export", :controller=>"admin/activities"}
#                delete_admin_activity GET    /admin/activities/:id/delete(.:format)                           {:action=>"delete", :controller=>"admin/activities"}
#                     admin_activities GET    /admin/activities(.:format)                                      {:action=>"index", :controller=>"admin/activities"}
#                       admin_activity GET    /admin/activities/:id(.:format)                                  {:action=>"show", :controller=>"admin/activities"}
#                                      DELETE /admin/activities/:id(.:format)                                  {:action=>"destroy", :controller=>"admin/activities"}
#                            user_page        /:user(.:format)                                                 {:controller=>"users", :action=>"user_page"}
#             user_public_repositories GET    /:user/repositories(.:format)                                    {:action=>"public_repositories", :controller=>"repositories"}
#                       user_following GET    /:user/following(.:format)                                       {:action=>"following", :controller=>"users"}
#                       user_followers GET    /:user/followers(.:format)                                       {:action=>"followers", :controller=>"users"}
#                  user_reverse_follow PUT    /:user/reverse_follow(.:format)                                  {:action=>"reverse_follow", :controller=>"users"}
#                      user_repository        /:user/:repository(.:format)                                     {:controller=>"repositories", :action=>"tree"}
#             user_repository_watchers GET    /:user/:repository/watchers(.:format)                            {:action=>"watchers", :controller=>"repositories"}
#        user_repository_reverse_watch PUT    /:user/:repository/reverse_watch(.:format)                       {:action=>"reverse_watch", :controller=>"repositories"}
#                user_repository_forks GET    /:user/:repository/forks(.:format)                               {:action=>"forks", :controller=>"repositories"}
#                 user_repository_fork PUT    /:user/:repository/fork(.:format)                                {:action=>"fork", :controller=>"repositories"}
#                admin_user_repository GET    /:user/:repository/admin(.:format)                               {:action=>"admin", :controller=>"repositories"}
#                 tree_user_repository        /:user/:repository/tree(/:tree_path)(.:format)                   {:controller=>"repositories", :action=>"tree"}
#                 blob_user_repository        /:user/:repository/blob/:blob_path(.:format)                     {:blob_path=>/.*/, :controller=>"repositories", :action=>"blob"}
#                               issues GET    /:user/:repository/issues(.:format)                              {:action=>"index", :controller=>"issues"}
#                                      POST   /:user/:repository/issues(.:format)                              {:action=>"create", :controller=>"issues"}
#                            new_issue GET    /:user/:repository/issues/new(.:format)                          {:action=>"new", :controller=>"issues"}
#                           edit_issue GET    /:user/:repository/issues/:id/edit(.:format)                     {:action=>"edit", :controller=>"issues"}
#                                issue GET    /:user/:repository/issues/:id(.:format)                          {:action=>"show", :controller=>"issues"}
#                                      PUT    /:user/:repository/issues/:id(.:format)                          {:action=>"update", :controller=>"issues"}
#                                      DELETE /:user/:repository/issues/:id(.:format)                          {:action=>"destroy", :controller=>"issues"}
#                                             /user_mailer_view                                                {:action=>"user_mailer_view", :to=>UserMailer::Preview}
#                                 page        /pages/*id                                                       {:controller=>"high_voltage/pages", :action=>"show"}
