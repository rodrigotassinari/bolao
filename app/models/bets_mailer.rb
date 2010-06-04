class BetsMailer < ActionMailer::Base

  def scored(options={})
    recipient = User.find(options['user_id'])
    bet       = Bet.find(options['bet_id'])
    game      = Game.find(options['game_id'])

    subject    "[#{Settings.email.subject_tag}] Você marcou #{bet.points} pontos no jogo #{game.short_description}"
    recipients "#{recipient.name} <#{recipient.email}>"
    from       Settings.email.from
    sent_on    Time.current
    tag        "scored"
    body       :recipient => recipient, :bet => bet, :game => game
  end

end
