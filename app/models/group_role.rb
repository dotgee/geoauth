class GroupRole < ActiveRecord::Base
  attr_accessible :role_id, :group_id, :groupname

  validates :role_id, presence: true
  validates :groupname, presence: true
  validates :role_id, uniqueness: { scope: :groupname }

  before_validation :ensure_groupname

  belongs_to :group
  belongs_to :role

  private
    def ensure_groupname
      if self.group
        self.groupname = self.group.name
      elsif self.group_id
        self.groupname = Group.find(self.group_id).name
      end
    end
end
