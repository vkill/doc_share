hyp = User.make!(:email => '122755990@qq.com', :username => 'hyphyp',
                  :password => 123456, :password_confirmation => 123456)
hyp.activate!
hyp.save


vkill = User.make!(:email => 'vkill.net@gmail.com', :username => 'vkill',
                  :password => 123456, :password_confirmation => 123456)
vkill.is_super_admin = true
vkill.activate!
vkill.save


hyp = User.find_by_email "122755990@qq.com"
vkill = User.find_by_email "vkill.net@gmail.com"

10.times {
  Message.make!(:sender => vkill, :receiver => hyp)
  Message.make!(:sender => hyp, :receiver => vkill)
}

10.times {
  repository = Repository.make!(:user => vkill)
  Repository.make!(:user => hyp, :parent => repository) if rand(2) == 0 #hyp fork vkill'repository
  target_follower = TargetFollower.make!(:follower => hyp, :target => repository) #hyp watch vkill'repository
  target_follower.destroy if rand(2) == 0 #vkill unwatch hyp'repository

  issue = Issue.make!(:user => vkill, :repository => repository)
  Comment.make!(:user => vkill, :commentable => repository)
  Comment.make!(:user => vkill, :commentable => issue)
  RepoFile.make!(:repository => repository)
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

