class RepoFile < ActiveRecord::Base

  belongs_to :repository, :counter_cache => true

  mount_uploader :file, FileUploader

#  validates :file, :presence => true



end

# == Schema Information
#
# Table name: repo_files
#
#  id            :integer         not null, primary key
#  repository_id :integer
#  file          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

