class Account::RepoFilesController < Account::BaseController

  respond_to :html
  respond_to :json, :only => [:create]

  before_filter :find_repository
  before_filter :find_or_build_repo_file, :except => [:index]

  def index
    @repo_files = @repository.repo_files
    render :json => @repo_files.collect { |repo_file| repo_file.to_jquery_fileupload }.to_json
  end

  def new
  end

  def create
    if @repo_file.save
      render :json => @repo_file.to_jquery_fileupload.to_json
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @repo_file.destroy
    render :json => true
  end

  private
    def find_repository
      @repository = current_user.repositories.find(params[:repository_id])
    end

    def find_or_build_repo_file
      @repo_file = params[:id] ? @repository.repo_files.find(params[:id]) : @repository.repo_files.build(params[:repo_file])
    end
end

