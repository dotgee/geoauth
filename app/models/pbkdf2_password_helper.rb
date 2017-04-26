require 'pbkdf2'
require 'base64'
require 'securerandom'

class PBKDF2PasswordHelper
	class << self
		def pbkdf2_hash(clear_password, stretches = 1000, salt = nil, algo = 'sha256', key_length = 24)
			salt ||= SecureRandom.hex(32)
			digest = PBKDF2.new(password: clear_password, salt: salt, iterations: stretches.to_i, hash_function: algo, key_length: key_length).bin_string
		end

		def pbkdf2_encode(clear_password, stretches = 1000, salt = nil, algo = 'sha256', key_length = 24)
			salt ||= SecureRandom.hex(32)
			digest = pbkdf2_hash(clear_password, stretches, salt, algo, key_length)

  		"#{algo}:#{stretches}:#{salt}:#{Base64.strict_encode64(digest)}"
		end

		def pbkdf2_compare(encrypted_password, clear_password)
			algo, iterations, salt, b64hash = encrypted_password.split(':')
			Devise.secure_compare(b64hash, pbkdf2_hash(clear_password, iterations, salt, algo))
		end
	end
end
