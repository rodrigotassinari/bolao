class BetsMailer < ActionMailer::Base

  def scored(user_id, bet_id, game_id)
    recipient = User.find(user_id)
    bet = Bet.find(bet_id)
    game = Game.find(game_id)

    subject    "[#{Settings.email.subject_tag}] Você marcou pontos no bolão!"
    recipients "#{recipient.name} <#{recipient.email}>"
    from       Settings.email.from
    sent_on    Time.current
    tag        "scored"
    
    body       :recipient => recipient, :bet => bet, :game => game
  end

end
