class Category < ActiveRecord::Base

  #
  has_ancestry

  attr_accessible :name, :code

  has_many :repositories, :dependent => :destroy

  validates :name, :code, :presence => true, :uniqueness => true

  basic_attr_accessible = [:parent, :name, :code]
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible), :as => :admin

  def self.get_parent_categories_values
    self.select([:id, :name]).map{|x| [x.name, x.id]}
  end

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

