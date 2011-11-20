class Message < ActiveRecord::Base

  belongs_to :sender,   :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

end

# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  sender_id   :integer
#  recerver_id :integer
#  category    :string(255)
#  content     :text
#  is_readed   :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

