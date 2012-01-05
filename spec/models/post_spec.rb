require 'spec_helper'

describe Post do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: posts
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  title          :string(255)
#  permalink      :string(255)
#  content        :text
#  is_top         :boolean
#  category       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  comments_count :integer
#

