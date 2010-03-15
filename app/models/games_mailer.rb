class GamesMailer < ActionMailer::Base

  def available_to_bet(recipient, game)
    subject    '[Bolão] Novo jogo disponível para palpite'
    recipients recipient.email
    from       'Bolão PiTTlândia Copa 2010 <no-reply@bolao.pittlandia.net>'
    sent_on    Time.current
    
    body       :recipient => recipient, :game => game
  end

end

