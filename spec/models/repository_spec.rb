require 'spec_helper'

describe Repository do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: repositories
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  category_id    :integer
#  ancestry       :string(255)
#  deleted        :boolean         default(FALSE)
#  name           :string(255)
#  describtion    :text
#  visibility     :string(255)
#  features       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  watchers_count :integer         default(0)
#  issues_count   :integer         default(0)
#

