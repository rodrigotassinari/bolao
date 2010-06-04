class MailJob
  @queue = :emails

  def self.perform(mailer_klass, mailer_method, options={})
    klass = mailer_klass.constantize
    method = mailer_method.to_sym
    klass.send(method, options)
  end
  
end
