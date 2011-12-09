class Account::RepoFilesController < Account::BaseController

  respond_to :html
  respond_to :json, :only => [:index, :check_exist, :create, :destory]

  before_filter :find_repository
  before_filter :find_or_build_repo_file, :except => [:index, :exist]
  before_filter :set_content_type, :only => [:create]

  def index
    @repo_files = @repository.repo_files
    respond_with do |format|
      format.json {
        render :json => @repo_files.collect { |repo_file| repo_file.to_jquery_fileupload }.to_json
      }
    end
  end

  def exist
    if @repository.repo_files.repo_file_exist?(params[:repo_file_name])
      respond_with do |format|
        format.json { render :json => true }
      end
    else
      respond_with do |format|
        format.json { render :json => false }
      end
    end
  end

  def new
  end

  def create
    if @repo_file.save
      respond_with do |format|
        format.json { render :json => [@repo_file.to_jquery_fileupload].to_json }
      end
    else
      respond_with do |format|
        format.json { render :json => [{:error => @repo_file.errors[:repo_file]}].to_json }
      end
    end
  end

  def destroy
    @repo_file.destroy
    respond_with do |format|
        format.json { render :json => true }
    end
  end

  private
    def find_repository
      @repository = current_user.repositories.find(params[:repository_id])
    end

    def find_or_build_repo_file
      @repo_file = params[:id] ? @repository.repo_files.find(params[:id]) : @repository.repo_files.build(params[:repo_file])
    end

    def set_content_type
      response.headers["Content-Type"] = "text/javascript; charset=utf-8" if params["format"].to_s == 'json'
    end

end

