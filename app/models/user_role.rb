class UserRole < ActiveRecord::Base
  track_who_does_it
  # attr_accessible :role_id, :user_id, :username

  validates :role_id, presence: true
  validates :username, presence: true
  validates :role_id, uniqueness: { scope: :username }

  before_validation :ensure_username

  belongs_to :user, counter_cache: :roles_count
  belongs_to :role, counter_cache: :users_count

  private
    def ensure_username
      if self.user
        self.username = self.user.username
      elsif self.user_id
        self.username = User.find(self.user_id).username
      end
    end
end
