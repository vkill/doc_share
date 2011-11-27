class RepoFile < ActiveRecord::Base

  attr_accessible :repository

  belongs_to :repository, :counter_cache => true

  mount_uploader :repo_file, FileUploader

  validates :repo_file, :presence => true

  default_scope order('created_at DESC')

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

