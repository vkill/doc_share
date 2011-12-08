class RepoFileObserver < ActiveRecord::Observer

  observe :repo_file

  def after_create(record)
    r = Grit::Repo.new record.git_repo_path
    i = Grit::Index.new(r)
    i.add(record.repo_file.file.filename, record.repo_file.file.to_file)
    i.commit "add #{ record.repo_file.file.filename }", r.commits
  end

  def after_update(record)
    r = Grit::Repo.new record.git_repo_path
    i = Grit::Index.new(r)
    i.add(record.repo_file.file.filename, record.repo_file.file.to_file)
    i.commit "update #{ record.repo_file.file.filename }", r.commits
  end

  def after_destroy(record)
    r = Grit::Repo.new record.git_repo_path
    i = Grit::Index.new(r)
    i.delete(record.repo_file.file.filename)
    i.commit "delete #{ record.repo_file.file.filename }", r.commits
  end

end

