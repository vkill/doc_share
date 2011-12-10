class RepoFileObserver < ActiveRecord::Observer

  observe :repo_file

  def after_create(record)
    r = record.git_repo
    i = r.index
    i.read_tree "master"
    i.add(record.repo_file.file.filename, record.repo_file.file.to_file.read)
    i.commit "add #{ record.repo_file.file.filename }", r.commits
  end

  def after_update(record)
    r = record.git_repo
    i = r.index
    i.read_tree "master"
    i.add(record.repo_file.file.filename, record.repo_file.file.to_file.read)
    i.commit "update #{ record.repo_file.file.filename }", r.commits
  end

  def after_destroy(record)
    r = record.git_repo
    i = r.index
    i.read_tree "master"
    i.delete(record.repo_file.file.filename)
    i.commit "delete #{ record.repo_file.file.filename }", r.commits
  end

end

