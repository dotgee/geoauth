# require 'openssl'
require 'digest'
require 'base64'

class StandardByteDigester
  def initialize(bitlen = 256, stretches = 1, salt_size = 0)
    @digester = Digest::SHA2.new(bitlen)
    @stretches = stretches
    @salt_size = salt_size
    @use_salt = salt_size > 0 ? true : false
  end

  #
  # From devise
  #

  class ::String
    def blank?
      return true if self.nil? || self.length == 0
      false
    end
  end

  class << self
    def secure_compare(a, b)
      return false if a.blank? || b.blank? || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end
  end

  def digest(message)
    return nil if message.nil?

    digest_with_salt(message, random_salt)
  end

  def matches(message, digest)
    salt = nil
    if (@use_salt)
      salt = digest[0...@salt_size]
      # puts "extract salt from digest #{@salt_size} |#{salt}|"
    end

    encrypted_message = digest_with_salt(message, salt)

    # puts "#{salt} |#{Base64.encode64(encrypted_message)}| #{Base64.encode64(digest)}"

    return StandardByteDigester.secure_compare(encrypted_message, digest)
  end

  private
    def random_salt
      salt = (0...@salt_size).map{ ('a'..'z').to_a[rand(26)] }.join
      salt
    end

    def digest_with_salt(message, salt)
      @digester.reset
      @digester << salt
      @digester << message

      digest = @digester.digest
      ( @stretches - 1 ).times do
        @digester.reset
        @digester << digest
        digest = @digester.digest
      end

      return salt + digest
    end
end

module Devise
  module Encryptable
    module Encryptors
      class ByteDigesterEncryptor < Base
        SALT_SIZE = 16

        def self.digest(password, stretches, salt, pepper)
          digester = StandardByteDigester.new(256, stretches, SALT_SIZE)
          digest = digester.digest(password)
          "digest1:#{Base64.encode64(digest)}"
        end

        # def self.salt(stretches)
        #   "$6$#{Devise.friendly_token[0,2]}$"
        # end

        def self.compare(encrypted_password, password, stretches, salt, pepper)
          raise "Unknown password encryptor" unless encrypted_password.match(/^digest1:(.*)/)
          check_password = encrypted_password.gsub(/^digest1:/, '') # $1
          digester = StandardByteDigester.new(256, stretches, SALT_SIZE)
          digester.matches(password, Base64.decode64(check_password))
        end
      end
    end
  end
end

