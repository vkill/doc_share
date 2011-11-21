class Repository < ActiveRecord::Base

  belongs_to :user
  belongs_to :category
  has_many :repo_files
  has_many :issues
  has_many :comments, :as => :commentable

  has_many :follower_followed, :as => :follower
  with_options :through => :follower_followed, :source => :follower do |target|
    target.has_many :watchers, :source_type => 'User'
  end

  validates :name, :presence => true,
                      :length => { :within => 6..30 }
  symbolize :visibility, :in => [:public, :private],
                    :scopes => true, :i18n => true,
                    :methods => true, :default => :public

end

# == Schema Information
#
# Table name: repositories
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  category_id    :integer
#  ancestry       :string(255)
#  deleted        :boolean         default(FALSE)
#  name           :string(255)
#  describtion    :text
#  visibility     :string(255)
#  features       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  watchers_count :integer         default(0)
#  issues_count   :integer         default(0)
#

