class Category < ActiveRecord::Base

  #
  has_ancestry

  #
  include RandomScope

  attr_accessible :name, :code

  has_many :repositories, :dependent => :destroy

  validates :name, :code, :presence => true, :uniqueness => true

  basic_attr_accessible = [:parent, :name, :code]
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible), :as => :admin

  scope :parents, where(:ancestry => nil).where{(name !~ "name_%")}
  scope :children, where{(ancestry != nil)}

  def self.list
    Hash[ Category.parents.map{|parent_category| [parent_category, parent_category.children]} ] 
  end

  def parent?
    self.class.parents.exists?(self)
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

