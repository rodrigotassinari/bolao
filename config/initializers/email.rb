ActionMailer::Base.delivery_method = Settings.email.delivery_method
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = 'utf-8'

if ActionMailer::Base.delivery_method == :postmark
  ActionMailer::Base.postmark_api_key = Settings.email.postmark_api_key
end

if ActionMailer::Base.delivery_method == :smtp
  ActionMailer::Base.smtp_settings = {
    :address => Settings.email.address,
    :port => Settings.email.port,
    :domain => Settings.email.domain,
    :authentication => Settings.email.authentication,
    :user_name => Settings.email.user_name,
    :password => Settings.email.password
  }
end

#ActionMailer::Base.perform_deliveries = true # DEBUG
ActionMailer::Base.perform_deliveries = Rails.env.production? ? true : false
