class GamesMailer < ActionMailer::Base

  def available_to_bet(recipient, game)
    subject    "[#{Settings.email.subject_tag}] Novo jogo disponível para palpite"
    recipients "#{recipient.name} <#{recipient.email}>"
    from       Settings.email.from
    sent_on    Time.current
    tag        "avaiable_to_bet"
    
    body       :recipient => recipient, :game => game
  end

end
