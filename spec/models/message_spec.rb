require 'spec_helper'

describe Message do
  pending "add some examples to (or delete) #{__FILE__}"
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

