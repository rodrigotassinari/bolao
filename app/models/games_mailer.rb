class GamesMailer < ActionMailer::Base

  def available_to_bet(options={})
    recipient = User.find(options['user_id'])
    game      = Game.find(options['game_id'])

    subject    "[#{Settings.email.subject_tag}] Novo jogo disponível para palpite: #{game.short_description}"
    recipients "#{recipient.name} <#{recipient.email}>"
    from       Settings.email.from
    sent_on    Time.current
    tag        "avaiable_to_bet"
    
    body       :recipient => recipient, :game => game
  end

end
