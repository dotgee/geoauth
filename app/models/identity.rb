class Identity < ActiveRecord::Base
  belongs_to :user

  validates :provider, presence: true
  # validates :extern_uid, allow_blank: true, uniqueness: { scope: :provider }
  validates :extern_uid, uniqueness: { scope: :provider }
  validates :user_id, uniqueness: { scope: :provider }

  #
  # from http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  #

  def self.find_for_oauth(auth)
    find_or_create_by(extern_uid: auth.uid, provider: auth.provider)
  end
end
