DocShare::Application.routes.draw do

  root :to => 'home#index'

  #user signup signin signout, user edit profile
  resources :users, :except => [:index, :show] do
    collection do
      get :autocomplete_with_username
    end
    member do
      get :activate
      put :password_update
    end
  end
  resources :sessions, :only => [:new, :create]
  resources :reset_passwords, :only => [:new, :create, :edit, :update]
  get "auth/signup" => "users#new", :as => "signup"
  get "auth/signin" => "sessions#new", :as => "signin"
  get "auth/signout" => "sessions#destroy", :as => "signout"
  get "account/edit" => "users#edit", :as => :edit_profile


  #
  resources :users, :only => [:index]
  #
  resources :repositories, :only => [:index]
  #
  get "search" => "search#index", :as => :search
  #
  resources :feedbacks, :only => [:index, :new, :create]
  #
  resources :posts, :only => [:index, :show], :path => "/blog"

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
    resources :activities, :only => [:index] do
      get :about_me, :on => :collection
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
      resources :repo_files, :only => [] do
        get :download_repo_file, :on => :member
      end
    end
    resources :activities, :only => [:index, :show] do
      get :export, :on => :collection
    end
    resources :site_configs, :only => [:index, :update] do
      post :reinitialize, :on => :collection
    end
    resources :backups, :only => [] do
      collection do
        get :download
        delete :delete
        get :databases
        post :backup_database
      end
    end
    resources :feedbacks, :except => [:new, :create] do
      get :export, :on => :collection
      get :delete, :on=> :member
      get :download_attachment, :on => :member
    end
    resources :posts do
      get :export, :on => :collection
      get :delete, :on=> :member
    end
  end


  # mail preview
  if Rails.env.development?
    # mount UserMailer::Preview => 'mailer_view_user'
    mount UserNotificationsMailer::Preview => 'mailer_view_user_notifications'
  end

  # high_voltage
  resources :pages

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

  # vidibus-routing_error
  # match "routing_error" => "home#rescue_404"
  # when use vidibus-routing_error, please drop this
  match "*path" => "home#rescue_404"

end

#== Route Map
# Generated on 05 Jan 2012 11:17
#
#              autocomplete_with_username_users GET    /users/autocomplete_with_username(.:format)                                    {:action=>"autocomplete_with_username", :controller=>"users"}
#                                 activate_user GET    /users/:id/activate(.:format)                                                  {:action=>"activate", :controller=>"users"}
#                          password_update_user PUT    /users/:id/password_update(.:format)                                           {:action=>"password_update", :controller=>"users"}
#                                         users POST   /users(.:format)                                                               {:action=>"create", :controller=>"users"}
#                                      new_user GET    /users/new(.:format)                                                           {:action=>"new", :controller=>"users"}
#                                     edit_user GET    /users/:id/edit(.:format)                                                      {:action=>"edit", :controller=>"users"}
#                                          user PUT    /users/:id(.:format)                                                           {:action=>"update", :controller=>"users"}
#                                               DELETE /users/:id(.:format)                                                           {:action=>"destroy", :controller=>"users"}
#                                      sessions POST   /sessions(.:format)                                                            {:action=>"create", :controller=>"sessions"}
#                                   new_session GET    /sessions/new(.:format)                                                        {:action=>"new", :controller=>"sessions"}
#                               reset_passwords POST   /reset_passwords(.:format)                                                     {:action=>"create", :controller=>"reset_passwords"}
#                            new_reset_password GET    /reset_passwords/new(.:format)                                                 {:action=>"new", :controller=>"reset_passwords"}
#                           edit_reset_password GET    /reset_passwords/:id/edit(.:format)                                            {:action=>"edit", :controller=>"reset_passwords"}
#                                reset_password PUT    /reset_passwords/:id(.:format)                                                 {:action=>"update", :controller=>"reset_passwords"}
#                                        signup GET    /auth/signup(.:format)                                                         {:controller=>"users", :action=>"new"}
#                                        signin GET    /auth/signin(.:format)                                                         {:controller=>"sessions", :action=>"new"}
#                                       signout GET    /auth/signout(.:format)                                                        {:controller=>"sessions", :action=>"destroy"}
#                                  edit_profile GET    /account/edit(.:format)                                                        {:controller=>"users", :action=>"edit"}
#                                               GET    /users(.:format)                                                               {:action=>"index", :controller=>"users"}
#                                  repositories GET    /repositories(.:format)                                                        {:action=>"index", :controller=>"repositories"}
#                                        search GET    /search(.:format)                                                              {:action=>"index", :controller=>"search"}
#                                     feedbacks GET    /feedbacks(.:format)                                                           {:action=>"index", :controller=>"feedbacks"}
#                                               POST   /feedbacks(.:format)                                                           {:action=>"create", :controller=>"feedbacks"}
#                                  new_feedback GET    /feedbacks/new(.:format)                                                       {:action=>"new", :controller=>"feedbacks"}
#                                         posts GET    /blog(.:format)                                                                {:action=>"index", :controller=>"posts"}
#                                          post GET    /blog/:id(.:format)                                                            {:action=>"show", :controller=>"posts"}
#                                  account_root        /account(.:format)                                                             {:controller=>"account/main", :action=>"dashboard"}
#                             account_dashboard GET    /account/dashboard(.:format)                                                   {:action=>"dashboard", :controller=>"account/main"}
#                  account_notifications_center GET    /account/notifications_center(.:format)                                        {:action=>"notifications_center", :controller=>"account/main"}
#          manage_account_repository_repo_files GET    /account/repositories/:repository_id/repo_files/manage(.:format)               {:action=>"manage", :controller=>"account/repo_files"}
#           exist_account_repository_repo_files POST   /account/repositories/:repository_id/repo_files/exist(.:format)                {:action=>"exist", :controller=>"account/repo_files"}
#                 account_repository_repo_files GET    /account/repositories/:repository_id/repo_files(.:format)                      {:action=>"index", :controller=>"account/repo_files"}
#                                               POST   /account/repositories/:repository_id/repo_files(.:format)                      {:action=>"create", :controller=>"account/repo_files"}
#                  account_repository_repo_file DELETE /account/repositories/:repository_id/repo_files/:id(.:format)                  {:action=>"destroy", :controller=>"account/repo_files"}
#                          account_repositories GET    /account/repositories(.:format)                                                {:action=>"index", :controller=>"account/repositories"}
#                                               POST   /account/repositories(.:format)                                                {:action=>"create", :controller=>"account/repositories"}
#                        new_account_repository GET    /account/repositories/new(.:format)                                            {:action=>"new", :controller=>"account/repositories"}
#                       edit_account_repository GET    /account/repositories/:id/edit(.:format)                                       {:action=>"edit", :controller=>"account/repositories"}
#                            account_repository PUT    /account/repositories/:id(.:format)                                            {:action=>"update", :controller=>"account/repositories"}
#                                               DELETE /account/repositories/:id(.:format)                                            {:action=>"destroy", :controller=>"account/repositories"}
#                         sent_account_messages GET    /account/messages/sent(.:format)                                               {:action=>"sent", :controller=>"account/messages"}
#                notifications_account_messages GET    /account/messages/notifications(.:format)                                      {:action=>"notifications", :controller=>"account/messages"}
#                         reply_account_message PUT    /account/messages/:id/reply(.:format)                                          {:action=>"reply", :controller=>"account/messages"}
#                              account_messages GET    /account/messages(.:format)                                                    {:action=>"index", :controller=>"account/messages"}
#                                               POST   /account/messages(.:format)                                                    {:action=>"create", :controller=>"account/messages"}
#                           new_account_message GET    /account/messages/new(.:format)                                                {:action=>"new", :controller=>"account/messages"}
#                               account_message GET    /account/messages/:id(.:format)                                                {:action=>"show", :controller=>"account/messages"}
#                                               DELETE /account/messages/:id(.:format)                                                {:action=>"destroy", :controller=>"account/messages"}
#                   about_me_account_activities GET    /account/activities/about_me(.:format)                                         {:action=>"about_me", :controller=>"account/activities"}
#                            account_activities GET    /account/activities(.:format)                                                  {:action=>"index", :controller=>"account/activities"}
#                                     dashboard GET    /dashboard(.:format)                                                           {:action=>"dashboard", :controller=>"account/main"}
#                                    admin_root        /admin(.:format)                                                               {:controller=>"admin/main", :action=>"dashboard"}
#                               admin_dashboard GET    /admin/dashboard(.:format)                                                     {:action=>"dashboard", :controller=>"admin/main"}
#                            export_admin_roles GET    /admin/roles/export(.:format)                                                  {:action=>"export", :controller=>"admin/roles"}
#                             delete_admin_role GET    /admin/roles/:id/delete(.:format)                                              {:action=>"delete", :controller=>"admin/roles"}
#                                   admin_roles GET    /admin/roles(.:format)                                                         {:action=>"index", :controller=>"admin/roles"}
#                                               POST   /admin/roles(.:format)                                                         {:action=>"create", :controller=>"admin/roles"}
#                                new_admin_role GET    /admin/roles/new(.:format)                                                     {:action=>"new", :controller=>"admin/roles"}
#                               edit_admin_role GET    /admin/roles/:id/edit(.:format)                                                {:action=>"edit", :controller=>"admin/roles"}
#                                    admin_role GET    /admin/roles/:id(.:format)                                                     {:action=>"show", :controller=>"admin/roles"}
#                                               PUT    /admin/roles/:id(.:format)                                                     {:action=>"update", :controller=>"admin/roles"}
#                                               DELETE /admin/roles/:id(.:format)                                                     {:action=>"destroy", :controller=>"admin/roles"}
#                            export_admin_users GET    /admin/users/export(.:format)                                                  {:action=>"export", :controller=>"admin/users"}
#                             delete_admin_user GET    /admin/users/:id/delete(.:format)                                              {:action=>"delete", :controller=>"admin/users"}
#                                   admin_users GET    /admin/users(.:format)                                                         {:action=>"index", :controller=>"admin/users"}
#                                               POST   /admin/users(.:format)                                                         {:action=>"create", :controller=>"admin/users"}
#                                new_admin_user GET    /admin/users/new(.:format)                                                     {:action=>"new", :controller=>"admin/users"}
#                               edit_admin_user GET    /admin/users/:id/edit(.:format)                                                {:action=>"edit", :controller=>"admin/users"}
#                                    admin_user GET    /admin/users/:id(.:format)                                                     {:action=>"show", :controller=>"admin/users"}
#                                               PUT    /admin/users/:id(.:format)                                                     {:action=>"update", :controller=>"admin/users"}
#                                               DELETE /admin/users/:id(.:format)                                                     {:action=>"destroy", :controller=>"admin/users"}
#                         export_admin_messages GET    /admin/messages/export(.:format)                                               {:action=>"export", :controller=>"admin/messages"}
#                          delete_admin_message GET    /admin/messages/:id/delete(.:format)                                           {:action=>"delete", :controller=>"admin/messages"}
#                                admin_messages GET    /admin/messages(.:format)                                                      {:action=>"index", :controller=>"admin/messages"}
#                                               POST   /admin/messages(.:format)                                                      {:action=>"create", :controller=>"admin/messages"}
#                             new_admin_message GET    /admin/messages/new(.:format)                                                  {:action=>"new", :controller=>"admin/messages"}
#                            edit_admin_message GET    /admin/messages/:id/edit(.:format)                                             {:action=>"edit", :controller=>"admin/messages"}
#                                 admin_message GET    /admin/messages/:id(.:format)                                                  {:action=>"show", :controller=>"admin/messages"}
#                                               PUT    /admin/messages/:id(.:format)                                                  {:action=>"update", :controller=>"admin/messages"}
#                                               DELETE /admin/messages/:id(.:format)                                                  {:action=>"destroy", :controller=>"admin/messages"}
#                       export_admin_categories GET    /admin/categories/export(.:format)                                             {:action=>"export", :controller=>"admin/categories"}
#                         delete_admin_category GET    /admin/categories/:id/delete(.:format)                                         {:action=>"delete", :controller=>"admin/categories"}
#                              admin_categories GET    /admin/categories(.:format)                                                    {:action=>"index", :controller=>"admin/categories"}
#                                               POST   /admin/categories(.:format)                                                    {:action=>"create", :controller=>"admin/categories"}
#                            new_admin_category GET    /admin/categories/new(.:format)                                                {:action=>"new", :controller=>"admin/categories"}
#                           edit_admin_category GET    /admin/categories/:id/edit(.:format)                                           {:action=>"edit", :controller=>"admin/categories"}
#                                admin_category GET    /admin/categories/:id(.:format)                                                {:action=>"show", :controller=>"admin/categories"}
#                                               PUT    /admin/categories/:id(.:format)                                                {:action=>"update", :controller=>"admin/categories"}
#                                               DELETE /admin/categories/:id(.:format)                                                {:action=>"destroy", :controller=>"admin/categories"}
#                     export_admin_repositories GET    /admin/repositories/export(.:format)                                           {:action=>"export", :controller=>"admin/repositories"}
#                       delete_admin_repository GET    /admin/repositories/:id/delete(.:format)                                       {:action=>"delete", :controller=>"admin/repositories"}
# download_repo_file_admin_repository_repo_file GET    /admin/repositories/:repository_id/repo_files/:id/download_repo_file(.:format) {:action=>"download_repo_file", :controller=>"admin/repo_files"}
#                            admin_repositories GET    /admin/repositories(.:format)                                                  {:action=>"index", :controller=>"admin/repositories"}
#                                               POST   /admin/repositories(.:format)                                                  {:action=>"create", :controller=>"admin/repositories"}
#                          new_admin_repository GET    /admin/repositories/new(.:format)                                              {:action=>"new", :controller=>"admin/repositories"}
#                         edit_admin_repository GET    /admin/repositories/:id/edit(.:format)                                         {:action=>"edit", :controller=>"admin/repositories"}
#                              admin_repository GET    /admin/repositories/:id(.:format)                                              {:action=>"show", :controller=>"admin/repositories"}
#                                               PUT    /admin/repositories/:id(.:format)                                              {:action=>"update", :controller=>"admin/repositories"}
#                                               DELETE /admin/repositories/:id(.:format)                                              {:action=>"destroy", :controller=>"admin/repositories"}
#                       export_admin_activities GET    /admin/activities/export(.:format)                                             {:action=>"export", :controller=>"admin/activities"}
#                              admin_activities GET    /admin/activities(.:format)                                                    {:action=>"index", :controller=>"admin/activities"}
#                                admin_activity GET    /admin/activities/:id(.:format)                                                {:action=>"show", :controller=>"admin/activities"}
#               reinitialize_admin_site_configs POST   /admin/site_configs/reinitialize(.:format)                                     {:action=>"reinitialize", :controller=>"admin/site_configs"}
#                            admin_site_configs GET    /admin/site_configs(.:format)                                                  {:action=>"index", :controller=>"admin/site_configs"}
#                             admin_site_config PUT    /admin/site_configs/:id(.:format)                                              {:action=>"update", :controller=>"admin/site_configs"}
#                        download_admin_backups GET    /admin/backups/download(.:format)                                              {:action=>"download", :controller=>"admin/backups"}
#                          delete_admin_backups DELETE /admin/backups/delete(.:format)                                                {:action=>"delete", :controller=>"admin/backups"}
#                       databases_admin_backups GET    /admin/backups/databases(.:format)                                             {:action=>"databases", :controller=>"admin/backups"}
#                 backup_database_admin_backups POST   /admin/backups/backup_database(.:format)                                       {:action=>"backup_database", :controller=>"admin/backups"}
#                        export_admin_feedbacks GET    /admin/feedbacks/export(.:format)                                              {:action=>"export", :controller=>"admin/feedbacks"}
#                         delete_admin_feedback GET    /admin/feedbacks/:id/delete(.:format)                                          {:action=>"delete", :controller=>"admin/feedbacks"}
#            download_attachment_admin_feedback GET    /admin/feedbacks/:id/download_attachment(.:format)                             {:action=>"download_attachment", :controller=>"admin/feedbacks"}
#                               admin_feedbacks GET    /admin/feedbacks(.:format)                                                     {:action=>"index", :controller=>"admin/feedbacks"}
#                           edit_admin_feedback GET    /admin/feedbacks/:id/edit(.:format)                                            {:action=>"edit", :controller=>"admin/feedbacks"}
#                                admin_feedback GET    /admin/feedbacks/:id(.:format)                                                 {:action=>"show", :controller=>"admin/feedbacks"}
#                                               PUT    /admin/feedbacks/:id(.:format)                                                 {:action=>"update", :controller=>"admin/feedbacks"}
#                                               DELETE /admin/feedbacks/:id(.:format)                                                 {:action=>"destroy", :controller=>"admin/feedbacks"}
#                            export_admin_posts GET    /admin/posts/export(.:format)                                                  {:action=>"export", :controller=>"admin/posts"}
#                             delete_admin_post GET    /admin/posts/:id/delete(.:format)                                              {:action=>"delete", :controller=>"admin/posts"}
#                                   admin_posts GET    /admin/posts(.:format)                                                         {:action=>"index", :controller=>"admin/posts"}
#                                               POST   /admin/posts(.:format)                                                         {:action=>"create", :controller=>"admin/posts"}
#                                new_admin_post GET    /admin/posts/new(.:format)                                                     {:action=>"new", :controller=>"admin/posts"}
#                               edit_admin_post GET    /admin/posts/:id/edit(.:format)                                                {:action=>"edit", :controller=>"admin/posts"}
#                                    admin_post GET    /admin/posts/:id(.:format)                                                     {:action=>"show", :controller=>"admin/posts"}
#                                               PUT    /admin/posts/:id(.:format)                                                     {:action=>"update", :controller=>"admin/posts"}
#                                               DELETE /admin/posts/:id(.:format)                                                     {:action=>"destroy", :controller=>"admin/posts"}
#                                                      /mailer_view_user_notifications                                                {:action=>"mailer_view_user_notifications", :to=>UserNotificationsMailer::Preview}
#                                         pages GET    /pages(.:format)                                                               {:action=>"index", :controller=>"pages"}
#                                               POST   /pages(.:format)                                                               {:action=>"create", :controller=>"pages"}
#                                      new_page GET    /pages/new(.:format)                                                           {:action=>"new", :controller=>"pages"}
#                                     edit_page GET    /pages/:id/edit(.:format)                                                      {:action=>"edit", :controller=>"pages"}
#                                          page GET    /pages/:id(.:format)                                                           {:action=>"show", :controller=>"pages"}
#                                               PUT    /pages/:id(.:format)                                                           {:action=>"update", :controller=>"pages"}
#                                               DELETE /pages/:id(.:format)                                                           {:action=>"destroy", :controller=>"pages"}
#                                     user_page        /:user(.:format)                                                               {:controller=>"users", :action=>"user_page"}
#                      user_public_repositories GET    /:user/repositories(.:format)                                                  {:action=>"public_repositories", :controller=>"repositories"}
#                                user_following GET    /:user/following(.:format)                                                     {:action=>"following", :controller=>"users"}
#                                user_followers GET    /:user/followers(.:format)                                                     {:action=>"followers", :controller=>"users"}
#                           user_reverse_follow PUT    /:user/reverse_follow(.:format)                                                {:action=>"reverse_follow", :controller=>"users"}
#                               user_repository        /:user/:repository(.:format)                                                   {:controller=>"repositories", :action=>"tree"}
#                      user_repository_watchers GET    /:user/:repository/watchers(.:format)                                          {:action=>"watchers", :controller=>"repositories"}
#                 user_repository_reverse_watch PUT    /:user/:repository/reverse_watch(.:format)                                     {:action=>"reverse_watch", :controller=>"repositories"}
#                         user_repository_forks GET    /:user/:repository/forks(.:format)                                             {:action=>"forks", :controller=>"repositories"}
#                          user_repository_fork PUT    /:user/:repository/fork(.:format)                                              {:action=>"fork", :controller=>"repositories"}
#                         admin_user_repository GET    /:user/:repository/admin(.:format)                                             {:action=>"admin", :controller=>"repositories"}
#                          tree_user_repository        /:user/:repository/tree(/:tree_path)(.:format)                                 {:controller=>"repositories", :action=>"tree"}
#                          blob_user_repository        /:user/:repository/blob/:blob_path(.:format)                                   {:blob_path=>/.*/, :controller=>"repositories", :action=>"blob"}
#                                        issues GET    /:user/:repository/issues(.:format)                                            {:action=>"index", :controller=>"issues"}
#                                               POST   /:user/:repository/issues(.:format)                                            {:action=>"create", :controller=>"issues"}
#                                     new_issue GET    /:user/:repository/issues/new(.:format)                                        {:action=>"new", :controller=>"issues"}
#                                    edit_issue GET    /:user/:repository/issues/:id/edit(.:format)                                   {:action=>"edit", :controller=>"issues"}
#                                         issue GET    /:user/:repository/issues/:id(.:format)                                        {:action=>"show", :controller=>"issues"}
#                                               PUT    /:user/:repository/issues/:id(.:format)                                        {:action=>"update", :controller=>"issues"}
#                                               DELETE /:user/:repository/issues/:id(.:format)                                        {:action=>"destroy", :controller=>"issues"}
#                                                      /*path(.:format)                                                               {:path=>/.+?/, :controller=>"home", :action=>"rescue_404"}
#                                 routing_error        /routing_error(.:format)                                                       {:action=>"rescue", :controller=>"routing_error"}
#                                          page        /pages/*id                                                                     {:controller=>"high_voltage/pages", :action=>"show"}
