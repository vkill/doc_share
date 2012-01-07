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
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible + [:category]), :as => :admin

  belongs_to :received_messageable, :polymorphic => true, :counter_cache => :received_messages_count
  belongs_to :sent_messageable, :polymorphic => true, :counter_cache => :sent_messages_count

  attribute_enums :category, :in => [:system_notification, :member_mailbox], :default => :member_mailbox

  validates :topic, :presence => true,
                      :length => { :within => 4..30 }
  validates :body, :presence => true,
                      :length => { :within => 6..2000 }
  
  delegate :email, :username, :to => :sent_messageable
  delegate :email, :username, :to => :sent_messageable, :prefix => :sender
  delegate :email, :username, :to => :received_messageable, :prefix => :receiver

end
