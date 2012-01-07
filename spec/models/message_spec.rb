require 'spec_helper'

describe Message do
  pending "add some examples to (or delete) #{__FILE__}"
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

