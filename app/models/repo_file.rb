class RepoFile < ActiveRecord::Base

  attr_accessible :repository, :repo_file

  belongs_to :repository, :counter_cache => true

  mount_uploader :repo_file, FileUploader

  validates :repo_file, :presence => true

  default_scope order('created_at DESC')

  delegate :git_repo_path, :git_repo, :to => :repository

  validate :repo_file_uniqueness_with_repository

  private
    def repo_file_uniqueness_with_repository
      errors.add :repo_file, :taken if RepoFile.where(:repository_id => self.repository_id).where(:repo_file => self.repo_file.filename).exists?
    end
end

# == Schema Information
#
# Table name: repo_files
#
#  id            :integer         not null, primary key
#  repository_id :integer
#  repo_file     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

