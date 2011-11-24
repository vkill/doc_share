class Message < ActiveRecord::Base

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id',
                      :counter_cache => :sent_messages_count
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id',
                        :counter_cache => :received_messages_count

  validates :content, :presence => true,
                      :length => { :within => 6..2000 }
  symbolize :category, :in => [:system_notification, :member_mailbox],
                    :scopes => true, :i18n => true,
                    :methods => true, :default => :member_mailbox

  scope :unread, where(:is_readed => false)

  def readed?
    !!is_readed?
  end

  def read!
    self.is_readed = true
    self.save
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
#  is_readed   :boolean         default(FALSE)
#  target_id   :integer
#  target_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

