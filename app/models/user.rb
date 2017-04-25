class User < ActiveRecord::Base
  include SentientUser
  include Filterable

  searchable :email, :first_name, :last_name, :groups_name, :roles_name

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # acts_as_paranoid

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable,
         :encryptable, :encryptor => :byte_digester_encryptor

  #
  # Fake attribute for devise encryptable
  #
  attr_accessor :password_salt

  has_and_belongs_to_many :groups, :join_table => :users_groups

  #
  # oauth
  #
  has_many :identities, dependent: :destroy

  before_save :map_email_to_username

  scope :list, -> { order(:email) }

  def name
    [ first_name, last_name ].compact.join(' ')
  end


  def map_email_to_username
    return true unless respond_to?(:username)
    if self.username.blank? || (self.email_changed? && self.email_was == self.username)
      self.username = self.email
    end
  end


  class << self
    def find_for_oauth(auth, signed_in_resource = nil)

      # Get the identity and user if they exist
      identity = Identity.find_for_oauth(auth)

      # from http://davidlesches.com/blog/clean-oauth-for-rails-an-object-oriented-approach
      policy = "#{auth.provider}_policy".classify.constantize.new(auth)

      # If a signed_in_resource is provided it always overrides the existing user
      # to prevent the identity being locked with accidentally created accounts.
      # Note that this may leave zombie accounts (with no associated identity) which
      # can be cleaned up at a later date.
      user = signed_in_resource ? signed_in_resource : identity.user

      # Create the user if needed
      if user.nil?

        # Get the existing user by email if the provider gives us a verified email.
        # If no verified email was provided we assign a temporary email and ask the
        # user to verify it on the next step via UsersController.finish_signup
        # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        # email = auth.info.email if email_is_verified
        email = policy.email # we don't verify email
        user = User.where(email: email).first unless email.blank?

        # Create the user if it's a new registration
        if user.nil?

          user = User.new(
            first_name: policy.first_name,
            last_name: policy.last_name,
            #username: auth.info.nickname || auth.uid,
            email: !email.blank? ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid.gsub(/\@/, '_')}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
          )
          user.skip_confirmation! if user.respond_to?(:skip_confirmation)
          user.save!
        end
      end

      # Associate the identity with the user if needed
      if identity.user != user
        identity.user = user
        identity.save!
      end
      user
    end

    def rolify_hack(options = {})
      include Rolify::Role
      extend Rolify::Dynamic if Rolify.dynamic_shortcuts

      options.reverse_merge!({:role_cname => 'Role'})

      rolify_options = { :class_name => options[:role_cname].camelize }
      # rolify_options.merge!({ :join_table => "#{self.to_s.tableize}_#{options[:role_cname].tableize}" }) if Rolify.orm == "active_record"
      rolify_options.merge!(options.reject{ |k,v| ![:before_add, :after_add, :before_remove, :after_remove].include? k.to_sym }) if Rolify.orm == "active_record"

      # has_and_belongs_to_many :roles, rolify_options
      has_many :user_roles, dependent: :destroy
      has_many :roles, rolify_options.merge!( { through: :user_roles } )

      self.adapter = Rolify::Adapter::Base.create("role_adapter", options[:role_cname], self.name)
      self.role_cname = options[:role_cname]

      load_dynamic_methods if Rolify.dynamic_shortcuts
    end
  end

  #
  # from http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  #
  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  rolify_hack

  def admin?
    admin_role = Settings.admin_role
    admin_role ||= "ROLE_ADMIN"

    has_role? admin_role
  end
end
