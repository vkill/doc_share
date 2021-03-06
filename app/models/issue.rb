class Issue < ActiveRecord::Base

  basic_attr_accessible = [:user_id, :title, :content, :user, :repository]
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible), :as => :admin

  belongs_to :user, :counter_cache => true
  belongs_to :repository, :counter_cache => true
  has_many :comments, :as => :commentable, :dependent => :destroy

  validates :title, :presence => true,
                      :length => { :within => 6..30 }
  validates :content, :presence => true,
                      :length => { :within => 6..2000 }
  attribute_enums :state, :in => [:open, :closed], :default => :open


  delegate :email, :username, :gravatar_url , :to => :user


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

