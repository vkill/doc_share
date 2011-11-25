class Issue < ActiveRecord::Base

  belongs_to :user, :counter_cache => true
  belongs_to :repository, :counter_cache => true
  has_many :comments, :as => :commentable

  validates :title, :presence => true,
                      :length => { :within => 6..30 }
  validates :content, :presence => true,
                      :length => { :within => 6..2000 }
  symbolize :state, :in => [:open, :closed],
                    :scopes => true, :i18n => true,
                    :methods => true, :default => :open


  delegate :email, :username, :to => :user

end

# == Schema Information
#
# Table name: issues
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  repository_id    :integer
#  title            :string(255)
#  content          :text
#  state            :string(255)
#  number_with_repo :integer
#  created_at       :datetime
#  updated_at       :datetime
#  comments_count   :integer         default(0)
#

