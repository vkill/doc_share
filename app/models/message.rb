class Message < ActiveRecord::Base

  has_ancestry
  paginates_per 10

  attr_accessor :receiver_username
  alias_attribute :user_id, :sender_id
  attr_accessible :user_id, :receiver_id, :subject, :content, :parent, :sender, :receiver, :user, :receiver_username

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id',
                      :counter_cache => :sent_messages_count
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id',
                        :counter_cache => :received_messages_count
  belongs_to :target, :polymorphic => true


  attribute_enums :category, :in => [:system_notification, :member_mailbox], :default => :member_mailbox
  attribute_enums :is_readed, :booleans => true
  validates :receiver_username, :presence => true,
                                :if => Proc.new { |record| record.receiver_id.blank? }
  validates :content, :presence => true,
                      :length => { :within => 6..2000 }
  validates :subject, :presence => true,
                      :length => { :within => 4..30 },
                      :unless => Proc.new { |record| record.ancestry? }

  scope :unread, where(:is_readed => false)
  scope :by_user, lambda {|user| where{(sender_id == user.id) | (receiver_id == user.id)} }

  delegate :email, :username, :to => :user

  after_validation :build_receiver_id, :if => Proc.new { |record| record.receiver_username.present? }

  def readed?
    !!is_readed?
  end

  def read!
    self.is_readed = true
    self.save
  end

  def reply!(content)
    new_message = Message.create(
      :receiver_username => sender.username,
      :content => content,
      :parent => self
    )
    new_message
  end

  private
    def build_receiver_id
      user = User.find_by_username(receiver_username.to_s)
      if user
        self.receiver_id = user.id
      else
        errors.add(:receiver_username, :existence)
      end
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

