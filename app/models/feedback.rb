class Feedback < ActiveRecord::Base

  alias_attribute :user_id, :handler_id

  belongs_to :handler, :class_name => 'User', :foreign_key => 'handler_id'

  attribute_enums :state, :in => [:pending, :processing, :processed], :default => :pending

  basic_attr_accessible = [:username, :email, :body]
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible + [:state, :result, :handler_id, :user_id]), :as => :admin

  validates :username, :presence => true,
                        :length => { :within => 4..30 },
                        :exclusion => { :in => Settings.user_username_exclusion_in.split(" ") }
  validates :email, :presence => true,
                    :email => true
  validates :body, :presence => true,
                      :length => { :within => 6..2000 }
  with_options :if => lambda { processed? } do |processed|
    processed.validates :result, :presence => true
  end
  with_options :if => lambda { processing? or processed? } do |processing_or_processed|
    processing_or_processed.before_save :build_handle_at
  end

  delegate :email, :username, :to => :handler, :prefix => true

  # Thinking Sphinx Indexing
  define_index do
    indexes body, :sortable => true
    indexes result
    has username, email, state, handler_id, handle_at, created_at, updated_at
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
#  created_at :datetime
#  updated_at :datetime
#

