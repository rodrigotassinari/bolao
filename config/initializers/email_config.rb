ActionMailer::Base.default_url_options[:host] = Settings.email.domain

if Rails.env.production? || Rails.env.staging?
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.default_charset = 'utf-8'
  ActionMailer::Base.default_url_options = { :host => Settings.email.host }

  ActionMailer::Base.smtp_settings = {
    :address => Settings.email.server,
    :domain => Settings.email.domain,
    :port => Settings.email.port,
    :authentication => :login,
    :user_name => Settings.email.login,
    :password => Settings.email.password
  }
end
