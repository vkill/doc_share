class Admin::PostsController < Admin::ResourcesBaseController

  before_filter :set_current_user, :only => [:create, :update]

  add_breadcrumb proc{|c| c.t("admin.shared.topbar.posts")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.shared.topbar.posts")}, :admin_posts_path, :except => [:index]
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]
  add_breadcrumb proc{|c| c.t("export_all")}, "", :only => [:export]

  add_breadcrumb proc{|c| "#{Post.model_name.human} ##{c.params[:id]}"}, proc{|c| c.admin_post_path},
                  :except => [:index, :new, :create, :export]
  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  add_breadcrumb proc{|c| c.t("delete")}, "", :only => [:delete, :destroy]

  private
    def association_chain
      Post.includes([:user])
    end

end
