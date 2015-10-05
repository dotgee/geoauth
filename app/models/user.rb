class User < ActiveRecord::Base
  include SentientUser
  
  # acts_as_paranoid

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :encryptor => :byte_digester_encryptor

  #
  # Fake attribute for devise encryptable
  #
  attr_accessor :password_salt

  has_and_belongs_to_many :groups, :join_table => :users_groups

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
    def rolify_hack(options = {})
      include Rolify::Role
      extend Rolify::Dynamic if Rolify.dynamic_shortcuts
    
      options.reverse_merge!({:role_cname => 'Role'})

      rolify_options = { :class_name => options[:role_cname].camelize }
      # rolify_options.merge!({ :join_table => "#{self.to_s.tableize}_#{options[:role_cname].tableize}" }) if Rolify.orm == "active_record"
      rolify_options.merge!(options.reject{ |k,v| ![:before_add, :after_add, :before_remove, :after_remove].include? k.to_sym }) if Rolify.orm == "active_record"

      # has_and_belongs_to_many :roles, rolify_options
      has_many :user_roles
      has_many :roles, rolify_options.merge!( { through: :user_roles } )

      self.adapter = Rolify::Adapter::Base.create("role_adapter", options[:role_cname], self.name)
      self.role_cname = options[:role_cname]
    
      load_dynamic_methods if Rolify.dynamic_shortcuts
    end
  end

  rolify_hack
end
