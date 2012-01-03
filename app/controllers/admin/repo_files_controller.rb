class Admin::RepoFilesController < Admin::ResourcesBaseController

  def download_repo_file
    send_file @repo_file.repo_file.file.to_file
  end

  private
    
    def association_chain
      Repository.includes([:user, :category]).find(params[:repository_id]).repo_files
    end

end
