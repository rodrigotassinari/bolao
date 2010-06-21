source 'http://rubygems.org'

# para agradar o passenger, que chama duas vezes Bundle.setup(), se não chamar
# o bundler no Gemfile ele vai achar que não tem bundler instalado, ver:
#   http://www.modrails.com/documentation/Users%20guide%20Apache.html#bundler_support
gem 'bundler' #, '0.9.26'

gem 'rails', '2.3.8'
gem 'mysql', '2.8.1'

gem 'haml', '3.0.12'
gem 'settingslogic', '2.0.6'
gem 'warden', '0.9.6'
gem 'devise', '1.0.4'
gem 'recaptcha', '0.2.3', :require => "recaptcha/rails"
gem 'googlecharts', '1.6.0'
gem 'postmark-rails'
gem 'resque', '1.9.5'

group :development do
  gem 'faker', '>= 0.3.1'
  gem 'capistrano'
  gem 'wirble'
  gem 'mongrel'
end

group :test do
  gem 'rspec-rails', '1.3.2'
  gem 'remarkable_rails', '3.1.13'
end
