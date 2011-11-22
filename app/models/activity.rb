class Activity < ActiveRecord::Base

  belongs_to :user
  belongs_to :target, :polymorphic => true



  def self.log!(attrs)
    self.create!(
      :user_id      => attrs[:user].id
      :action       => attrs[:action],
      :target_id    => attrs[:activity_target].id,
      :target_type  => attrs[:activity_target].class.name
    )
  end

end

