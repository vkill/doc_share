class Category < ActiveRecord::Base

  has_many :repositories

  validates :name, :code, :presence => true, :uniqueness => true

end

# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  ancestry   :string(255)
#  name       :string(255)
#  code       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

