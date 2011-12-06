class RepoFileObserver < ActiveRecord::Observer

  observe :repo_file

  def after_create(record)
    r = Grit::Repo.new record.git_repo_path
    i = r.index
    i.add(record.repo_file.file.filename, record.repo_file.file.to_file)
    i.commit "add #{ record.repo_file.file.filename }", [r.commits.last]
  end

  def after_destroy(record)
    r = Grit::Repo.new record.git_repo_path
    i = r.index
    i.delete(record.repo_file.file.filename)
    i.commit "delete #{ record.repo_file.file.filename }", [r.commits.last]
  end

end

