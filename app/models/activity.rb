class Activity < ActiveRecord::Base

  belongs_to :user
  belongs_to :target, :polymorphic => true

  attribute_enums :action, :in => [:created_repository, :destroyed_repository,
                              :followed_user, :unfollowed_user, :watched_repository, :unwatched_repository,
                              :forked_repository,
                              ]

  delegate :email, :username, :gravatar_url , :to => :user

  def self.log!(attrs)
    self.create!(
      :user_id      => attrs[:user].id,
      :user_name    => attrs[:user].username,
      :action       => attrs[:action],
      :target_id    => attrs[:activity_target].id,
      :target_type  => attrs[:activity_target].class.model_name
    )
  end

  def target_link_body
    [target_type, target_id].join("#")
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

