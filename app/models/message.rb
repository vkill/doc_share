class Message < ActiveRecord::Base

  has_ancestry
  paginates_per 10

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id',
                      :counter_cache => :sent_messages_count
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id',
                        :counter_cache => :received_messages_count
  belongs_to :target, :polymorphic => true


  validates :content, :presence => true,
                      :length => { :within => 6..2000 }
  symbolize :category, :in => [:system_notification, :member_mailbox],
                    :scopes => true, :i18n => true,
                    :methods => true, :default => :member_mailbox
  validates :subject, :presence => true,
                      :length => { :within => 4..30 },
                      :unless => Proc.new { |record| record.ancestry? }

  scope :unread, where(:is_readed => false)

  delegate :email, :username, :to => :user

  def readed?
    !!is_readed?
  end

  def read!
    self.is_readed = true
    self.save
  end

  def reply!(content)
    new_message = Message.create(
      :receiver => sender,
      :parent_id => id,
      :content => content
    )
    self.reload
    new_message
  end

end

# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  category    :string(255)
#  subject     :string(255)
#  content     :text
#  ancestry    :string(255)
#  is_readed   :boolean         default(FALSE)
#  target_id   :integer
#  target_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

