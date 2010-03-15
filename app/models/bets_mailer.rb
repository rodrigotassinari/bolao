class BetsMailer < ActionMailer::Base

  def scored(recipient, bet, game)
    subject    "[Bolão] Você marcou pontos no bolão!"
    recipients "#{recipient.name} <#{recipient.email}>"
    from       'Bolão PiTTlândia Copa 2010 <no-reply@bolao.pittlandia.net>'
    sent_on    Time.current
    
    body       :recipient => recipient, :bet => bet, :game => game
  end

end

