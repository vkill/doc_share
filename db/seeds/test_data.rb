TAG_LIST = %w( tag1 tag2 tag3 tag4 tag5 tag6 tag7 tag8 tag9 tag10 )

hyp = User.make!(:email => '122755990@qq.com', :username => 'hyphyp',
                  :password => 123456, :password_confirmation => 123456)
hyp.activate! if Rails.application.config.sorcery.submodules.include?(:user_activation)
hyp.save


vkill = User.make!(:email => 'vkill.net@gmail.com', :username => 'vkill',
                  :password => 123456, :password_confirmation => 123456)
vkill.is_super_admin = true
vkill.activate! if Rails.application.config.sorcery.submodules.include?(:user_activation)
vkill.save


hyp = User.find_by_email "122755990@qq.com"
vkill = User.find_by_email "vkill.net@gmail.com"

10.times {
  Message.make!(:sender => vkill, :receiver => hyp)
  Message.make!(:sender => hyp, :receiver => vkill)
}

10.times {
  repository = Repository.make!(:user => vkill)
  RepoFile.make!(:repository => repository)
  Repository.make!(:user => hyp, :parent => repository) if rand(2) == 0 #hyp fork vkill'repository
  target_follower = TargetFollower.make!(:follower => hyp, :target => repository) #hyp watch vkill'repository
  target_follower.destroy if rand(2) == 0 #vkill unwatch hyp'repository

  issue = Issue.make!(:user => vkill, :repository => repository)
  Comment.make!(:user => vkill, :commentable => repository)
  Comment.make!(:user => vkill, :commentable => issue)
  
  #create tag
  repository.tag_list = TAG_LIST.sort_by!{rand}.take(3)
  repository.save!
}

10.times {
  repository = Repository.make!(:user => hyp)
  Repository.make!(:user => vkill, :parent => repository) if rand(2) == 0 #vkill fork hyp'repository
  target_follower = TargetFollower.make!(:follower => vkill, :target => repository) #vkill watch hyp'repository
  target_follower.destroy if rand(2) == 0 #vkill unwatch hyp'repository
}

10.times {
  user = User.make!
  target_follower = TargetFollower.make!(:follower => vkill, :target => user)  #vkill follow user
  target_follower.destroy if rand(2) == 0 #vkill unfollow user
  target_follower = TargetFollower.make!(:follower => user, :target => vkill)  #user follow vkill
  target_follower.destroy if rand(2) == 0 #user unfollow vkill
}

#create top blogs and comment it
5.times {
  post = Post.make!(:category => :blog, :is_top => true)
  10.times {
    Comment.make!(:user => vkill, :commentable => post)
    Comment.make!(:user => hyp, :commentable => post)
  }
}
