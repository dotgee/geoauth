class Group < ActiveRecord::Base
  attr_accessible :description, :name
  
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :users, :join_table => :users_groups
end
