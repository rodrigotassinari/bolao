class EmailWorker < Workling::Base
  
  def games_available_to_bet(options)
    user = User.find(options[:user_id])
    game = Game.find(options[:game_id])
    logger.info "Enviando GamesMailer#available_to_bet(#{user.id}, #{game.id})..." 
    GamesMailer.deliver_available_to_bet(user, game)
  end
  
  def bets_scored(options)
    user = User.find(options[:user_id])
    bet = Bet.find(options[:bet_id])
    logger.info "Enviando BetsMailer#scored(#{user.id}, #{bet.id})..." 
    BetsMailer.deliver_scored(user, bet)
  end
  
end

