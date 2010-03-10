if Rails.env.production?
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.default_charset = 'utf-8'

  ActionMailer::Base.smtp_settings = {
    :address => "smtp.sendgrid.net",
    :port => 25,
    :domain => "bolao.pittlandia.net",
    :authentication => :plain,
    :user_name => "sendgrid@pittlandia.net",
    :password => "8g1903"
  }
else
  ActionMailer::Base.perform_deliveries = false
end

