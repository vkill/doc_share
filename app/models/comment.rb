class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user, :counter_cache => true

  basic_attr_accessible = [:user_id, :user, :content, :commentable, :commentable_id, :commentable_type]
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible), :as => :admin

  validates :content, :presence => true,
                      :length => { :within => 6..2000 }

  delegate :email, :username, :gravatar_url , :to => :user

  def html_anchor
    "comment-#{id}"
  end

end

# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  content          :text
#  created_at       :datetime
#  updated_at       :datetime
#

