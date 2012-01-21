class Feedback < ActiveRecord::Base

  STATES = [:pending, :processing, :processed]
  
  #attribute_enums
  attribute_enums :state, :in => STATES, :default => :pending

  #uploader
  mount_uploader :attachment, FeedbackAttachmentUploader

  # Thinking Sphinx Indexing
  define_index do
    indexes body, :sortable => true
    indexes result
    has username, email, state, handler_id, handle_at, created_at, updated_at
  end

  belongs_to :handler, :class_name => 'User', :foreign_key => 'handler_id'

  alias_attribute :user_id, :handler_id

  basic_attr_accessible = [:username, :email, :body, :attachment]
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible + [:state, :result, :user_id]), :as => :admin

  validates :attachment, :file_size => { :maximum => 0.5.megabytes.to_i },
                          :if => lambda { attachment? }
  validates :username, :presence => true,
                        :exclusion => { :in => Settings.user_username_exclusion_in.split(" ") }
  validates :email, :presence => true,
                    :email => true
  validates :body, :presence => true,
                      :length => { :within => 6..300 }
  with_options :if => lambda { processed? } do |processed|
    processed.validates :result, :presence => true
  end
  with_options :if => lambda { processing? or processed? } do |processing_or_processed|
    processing_or_processed.before_save :build_handle_at
    processing_or_processed.delegate :email, :username, :to => :handler, :prefix => true
  end

  private
    def build_handle_at
      self.handle_at = Time.zone.now
    end
end
# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer         not null, primary key
#  username   :string(255)
#  email      :string(255)
#  body       :text
#  state      :string(255)
#  result     :text
#  handler_id :integer
#  handle_at  :datetime
#  attachment :string(255)
#  created_at :datetime
#  updated_at :datetime
#

