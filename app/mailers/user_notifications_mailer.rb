class UserNotificationsMailer < ActionMailer::Base

  include Resque::Mailer

  default from: "137518792@qq.com"

  def user_followed_email(user, follower)
    @user = user
    @follower = follower
    @follower_url = user_page_url(@follower.username)
    mail(:to => @user.email,
         :subject => t("user_notifications_mailer.user_followed_email.subject", :user => @follower.username)
         )
  end

  def repository_watched_email(user, repository, watcher)
    @user = user
    @repository = repository
    @watcher = watcher
    @watcher_url = user_page_url(@watcher.username)
    mail(:to => @user.email,
         :subject => t("user_notifications_mailer.repository_watched_email.subject", :user => @watcher.username,
                                                                                    :repository => @repository.name)
        )
  end

  def repository_forked_email(user, repository, forker)
    @user = user
    @repository = repository
    @forker = forker
    @forker_url = user_page_url(@forker.username)
    mail(:to => @user.email,
         :subject => t("user_notifications_mailer.repository_forked_email.subject", :user => @forker.username,
                                                                                    :repository => @repository.name)
        )
  end

  if Rails.env.development?
    class Preview < MailView

      def user_followed_email
        user = User.new(:email => '122755990@qq.com', :username => 'vkill')
        follower = User.new(:username => 'hyphyp')
        ::UserNotificationsMailer.user_followed_email(user, follower)
      end

      def repository_watched_email
        user = User.new(:email => '122755990@qq.com', :username => 'vkill')
        repository = Repository.new(:name => 'repo_test')
        watcher = User.new(:username => 'hyphyp')
        ::UserNotificationsMailer.repository_watched_email(user, repository, watcher)
      end

      def repository_forked_email
        user = User.new(:email => '122755990@qq.com', :username => 'vkill')
        repository = Repository.new(:name => 'repo_test')
        forker = User.new(:username => 'hyphyp')
        ::UserNotificationsMailer.repository_forked_email(user, repository, forker)
      end

    end
  end

end
