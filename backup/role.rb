class Role < ActiveRecord::Base
  attr_accessible :description, :name
  validates :name, presence: true, uniqueness: true, length: { minimum: 4, maximum: 64 }

  has_many :user_roles
  has_namy :users, through: :user_roles

  scope :externals, where(:user_id => nil)

  def usernames
    externals.all.map(&:username) + users.map(&:email)
  end
end
