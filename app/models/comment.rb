class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user, :counter_cache => true

  validates :content, :presence => true,
                      :length => { :within => 6..2000 }

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

