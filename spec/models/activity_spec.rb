require 'spec_helper'

describe Activity do

  context "define scopes" do
    it { Activity.created_repository.new.action.to_s.should eq('created_repository') }
    it { Activity.destroyed_repository.new.action.to_s.should eq('destroyed_repository') }
    it { Activity.followed_user.new.action.to_s.should eq('followed_user') }
    it { Activity.unfollowed_user.new.action.to_s.should eq('unfollowed_user') }
    it { Activity.watched_repository.new.action.to_s.should eq('watched_repository') }
    it { Activity.unwatched_repository.new.action.to_s.should eq('unwatched_repository') }
    it { Activity.forked_repository.new.action.to_s.should eq('forked_repository') }
  end

end
# == Schema Information
#
# Table name: activities
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  user_name   :string(255)
#  action      :string(255)
#  target_id   :integer
#  target_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

