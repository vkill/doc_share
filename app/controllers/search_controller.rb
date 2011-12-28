class SearchController < ApplicationController

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.search")}, :search_path

  def index
    @search = Search.new(params[:search])
    @search.valid?
    if @search.q.blank?
      render :index
    else
      case @search.type.to_sym
      when :everything
        @users = User.search(@search.q).page(params[:page]).per(5)
        @repositories = Repository.search(@search.q).page(params[:page]).per(5)
        render :results_everything
      when :users
        @users = User.search(@search.q).page(params[:page]).per(10)
        render :results_users
      when :repositories
        @repositories = Repository.search(@search.q).page(params[:page]).per(10)
        render :results_repositories
      end
    end
  end

end
