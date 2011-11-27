class Category < ActiveRecord::Base

  attr_accessible :name, :code

  has_many :repositories

  validates :name, :code, :presence => true, :uniqueness => true

  default_scope order('created_at DESC')

end

# == Schema Information
#
# Table name: categories
#
#  id                 :integer         not null, primary key
#  ancestry           :string(255)
#  name               :string(255)
#  code               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  repositories_count :integer
#

