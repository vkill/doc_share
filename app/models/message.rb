class Message < ActsAsMessageable::Message

  attr_accessor :receiver_username_post

  basic_attr_accessible = [:topic,
                            :body,
                            :received_messageable_type,
                            :received_messageable_id,
                            :sent_messageable_type,
                            :sent_messageable_id,
                            :opened,
                            :recipient_delete,
                            :sender_delete,
                            :recipient_permanent_delete,
                            :sender_permanent_delete,
                            :created_at,
                            :updated_at]
  attr_accessible *(basic_attr_accessible + [:receiver_username_post])
  attr_accessible *(basic_attr_accessible + [:receiver_username_post, :category]), :as => :admin

  belongs_to :received_messageable, :polymorphic => true, :counter_cache => :received_messages_count
  belongs_to :sent_messageable, :polymorphic => true, :counter_cache => :sent_messages_count

  attribute_enums :category, :in => [:system_notification, :member_mailbox], :default => :member_mailbox
  attribute_enums :opened, :booleans => true

  validates :topic, :presence => true,
                      :length => { :within => 4..30 }
  validates :body, :presence => true,
                      :length => { :within => 6..2000 }
  
  delegate :email, :username, :to => :sent_messageable
  delegate :email, :username, :to => :sent_messageable, :prefix => :sender
  delegate :email, :username, :to => :received_messageable, :prefix => :receiver

  after_validation :build_received_messageable, :if => lambda { receiver_username_post.present? }

  def reply_topic
    "Re: #{self.topic}"
  end

  private
    def build_received_messageable
      user = User.find_by_username(receiver_username_post.to_s)
      if user
        self.received_messageable_type = user.class.name
        self.received_messageable_id = user.id
      else
        errors.add(:receiver_username_post, :existence)
      end
    end
end
# == Schema Information
#
# Table name: messages
#
#  id                         :integer         not null, primary key
#  topic                      :string(255)
#  body                       :text
#  received_messageable_id    :integer
#  received_messageable_type  :string(255)
#  sent_messageable_id        :integer
#  sent_messageable_type      :string(255)
#  opened                     :boolean         default(FALSE)
#  recipient_delete           :boolean         default(FALSE)
#  sender_delete              :boolean         default(FALSE)
#  created_at                 :datetime
#  updated_at                 :datetime
#  ancestry                   :string(255)
#  recipient_permanent_delete :boolean         default(FALSE)
#  sender_permanent_delete    :boolean         default(FALSE)
#  category                   :string(255)
#

