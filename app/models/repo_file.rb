class RepoFile < ActiveRecord::Base

  attr_accessible :repository, :repo_file

  belongs_to :repository, :counter_cache => true

  mount_uploader :repo_file, FileUploader

  validates :repo_file, :presence => true

  default_scope order('created_at DESC')
  scope :repo_file_exist?, Proc.new{|repo_file_name| where(:repo_file => repo_file_name).exists? }

  delegate :git_repo_path, :git_repo, :to => :repository

  validate :repo_file_uniqueness_with_repository

  # jquery_fileupload use
  include ::Rails.application.routes.url_helpers
  def to_jquery_fileupload
    {
      "name" => read_attribute(:repo_file),
      "size" => repo_file.size,
      "url" => repo_file.url,
      "thumbnail_url" => repo_file.url,
      "delete_url" => account_repository_repo_file_path(repository, id),
      "delete_type" => "DELETE"
     }
  end

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

