class UserMailer < ActionMailer::Base

  default from: "137518792@qq.com"

  def reset_password_email(user)
    @user = user
    @url = "http://0.0.0.0:3000/reset_passwords/#{user.reset_password_token}/edit"
    mail(:to => user.email,
         :subject => "Your password reset request")
  end

  def activation_needed_email(user)
    @user = user
    @url = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"
    mail(:to => user.email,
         :subject => "Welcome to My Awesome Site")
  end

  def activation_success_email(user)
    @user = user
    @url = "http://0.0.0.0:3000/login"
    mail(:to => user.email,
         :subject => "Your account is now activated")
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

