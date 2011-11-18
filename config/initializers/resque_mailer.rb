
Resque::Mailer.default_queue_name = 'mailer'

class AsyncMailer < ActionMailer::Base
  include Resque::Mailer
end
#
## app/mailers/example_mailer.rb
#class ExampleMailer < AsyncMailer
#  def say_hello(user)
#    # ...
#  end
#end

Resque::Mailer.excluded_environments = [:test, :cucumber]
