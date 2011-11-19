class TargetFollower < ActiveRecord::Base

  belongs_to :user, :primary_key => :follower_id
  belongs_to :follower, :polymorphic => true
  belongs_to :target, :polymorphic => true

end

# == Schema Information
#
# Table name: target_followers
#
#  id            :integer         not null, primary key
#  follower_id   :integer
#  follower_type :string(255)
#  target_id     :integer
#  target_type   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

