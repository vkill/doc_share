class Post < ActiveRecord::Base
  
  #stringex
  acts_as_url :title, :url_attribute => :permalink
  def to_param
    "#{id}-#{permalink}"
  end

  #acts-as-taggable-on
  acts_as_taggable

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy

  attribute_enums :is_top, :booleans => true
  attribute_enums :category, :in => [:notification, :blog], :default => :blog

  validates :title, :presence => true,
                    :uniqueness => true,
                    :length => { :maximum => 40 }
  validates :content, :presence => true,
                      :length => { :minimum => 2 }
  
  delegate :email, :username, :gravatar_url , :to => :user

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

