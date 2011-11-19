require 'spec_helper'

describe Issue do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: issues
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  repository_id    :integer
#  title            :string(255)
#  content          :text
#  state            :string(255)
#  number_with_repo :integer
#  created_at       :datetime
#  updated_at       :datetime
#  comments_count   :integer         default(0)
#

