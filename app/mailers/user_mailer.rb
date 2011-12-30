class UserMailer < ActionMailer::Base

  default from: "137518792@qq.com"

  def reset_password_email(user)
    @user = user
    @url = url_for(:controller => :reset_passwords, :action => :edit, :id => user.reset_password_token)
    mail(:to => user.email,
         :subject => t("user_mailer.reset_password_email.title"))
  end

  def activation_needed_email(user)
    @user = user
    @url = url_for(:controller => :users, :action => :activate, :id => user.activation_token)
    mail(:to => user.email,
         :subject => t("user_mailer.activation_needed_email.title"))
  end

  def activation_success_email(user)
    @user = user
    @url = signin_path(:only_path => false)
    mail(:to => user.email,
         :subject => t("user_mailer.activation_success_email.title"))
  end

  if Rails.env.development?
    class Preview < MailView

      def reset_password_email
        user = User.new(:email => '122755990@qq.com')
        user.reset_password_token = 'test'
        ::UserMailer.reset_password_email(user)
      end

      def activation_needed_email
        user = User.new(:email => '122755990@qq.com')
        user.activation_token = 'test'
        ::UserMailer.activation_needed_email(user)
      end

      def activation_success_email
        user = User.new(:email => '122755990@qq.com')
        ::UserMailer.activation_success_email(user)
      end

    end
  end

end

