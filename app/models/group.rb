class Group < ActiveRecord::Base
  track_who_does_it
#  attr_accessible :description, :name

  acts_as_paranoid

  scope :list, -> { order(:name) }

  validates :name, presence: true, uniqueness: true

  #
  # Why has_and_belongs_to_many and non has_many :through ?
  #
  has_and_belongs_to_many :members,
                          class_name: 'User',
                          join_table: :users_groups

  has_many :group_roles, dependent: :destroy
  has_many :roles, through: :group_roles

  class << self
    def public_groups
      where(public: true).order(:description).pluck(:description, :id)
    end

    def entity_groups
      where(entity: true).order(:description).pluck(:description, :id)
    end
  end
end
