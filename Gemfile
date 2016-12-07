source 'https://rubygems.org'

gem 'rails', '4.2.7.1'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem "compass-rails", "~> 1.0.3"
  gem "compass", "~> 0.12.2"
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
end

gem 'jquery-datatables-rails'

gem 'jquery-rails'
gem "unicorn", ">= 4.3.1"
gem "pg", ">= 0.14.1"
gem "slim"
gem 'slim-rails'
group :development do
  gem 'bullet'
  #
  # added by dotgee
  #
  gem 'mailcatcher'
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'rack-livereload'
  gem 'better_errors'
  gem 'binding_of_caller'
end

# gem "haml2slim", ">= 0.4.6", :group => :development
# gem "haml", ">= 3.1.6", :group => :development
# gem "haml-rails", ">= 0.3.5", :group => :development
# gem "hpricot", ">= 0.8.6", :group => :development


# gem "ruby_parser", ">= 2.3.1", :group => :development
gem "rspec-rails", ">= 2.11.4", :group => [:development, :test]
gem "capybara", ">= 1.1.2", :group => :test
gem "email_spec", ">= 1.2.1", :group => :test
gem "factory_girl_rails", ">= 4.1.0", :group => [:development, :test]
gem "bootstrap-sass"
gem 'bootstrap-sass-extras'
#gem 'font-awesome-rails'
gem 'font-awesome-sass', '~> 4.4.0'
gem "devise", ">= 2.1.2"
gem "devise_invitable", ">= 1.1.1"
gem "devise-encryptable"
gem 'devise-i18n'

gem "responders"

gem "simple_form", '>= 3'
gem "quiet_assets", ">= 1.0.1", :group => :development

gem 'puma'
gem 'god'

# gem 'sexp'
gem 'rolify'
gem 'cancancan'

gem 'wicked'

# gem 'libv8'
gem 'therubyracer'

gem 'kaminari'

#
# Manage created_by
#
gem 'sentient_user'
gem 'clerk'
gem "paranoia", "~> 2.0"
gem 'reform'
gem 'draper'

gem 'gravatar_image_tag'

gem 'ransack'

#
# omniauth integration
#
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-linkedin'
gem 'omniauth-shibboleth'
gem 'rack-saml', github: 'dotgee/rack-saml' # path: '../rack-saml-dotgee'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'


end

gem 'settingslogic'

gem 'figaro'
gem 'bugsnag'
gem 'newrelic_rpm'

gem 'dotenv-rails'
