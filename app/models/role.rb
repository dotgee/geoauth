class Role < ActiveRecord::Base
  track_who_does_it

  acts_as_paranoid

  scope :list, -> { order(:name) }
  # has_and_belongs_to_many :users, :join_table => :users_roles
  has_many :user_roles
  has_many :users, through: :user_roles

  has_many :properties, class_name: 'RoleProperty'

  belongs_to :resource, polymorphic: true
  
  scopify
end
