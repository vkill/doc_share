require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  content          :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

