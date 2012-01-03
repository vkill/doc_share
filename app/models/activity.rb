class Activity < ActiveRecord::Base

  belongs_to :user
  belongs_to :activityable, :polymorphic => true

  attribute_enums :action, :in => [:created_repository, :destroyed_repository,
                              :followed_user, :unfollowed_user, :watched_repository, :unwatched_repository,
                              :forked_repository,
                              ]

  delegate :email, :username, :gravatar_url , :to => :user

  scope :about_user, lambda { |user| where{(user_id >> user.following_user_ids) | \
                        ( (activityable_id >> user.watching_repository_ids) & (activityable_type == 'Repository') & \
                            (user_id != user.id) )} }

  def self.log!(attrs)
    self.create!(
      :user_id      => attrs[:user].id,
      :user_name    => attrs[:user].username,
      :action       => attrs[:action],
      :activityable_id    => attrs[:activity_target].id,
      :activityable_type  => attrs[:activity_target].class.model_name
    )
  end

  def target_link_body
    [activityable_type, activityable_id].join("#")
  end

end

# == Schema Information
#
# Table name: activities
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  user_name         :string(255)
#  action            :string(255)
#  activityable_id   :integer
#  activityable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

