class PagesController < ApplicationController

  def index
    @games_count = Game.count
    @users_count = User.count
    @bets_count = Bet.count
    @possible_bets_count = @users_count * @games_count
    @points_count = Bet.sum(:points)
    @total_prize = (User.paid.count * Bet::NET_VALUE)
  end
  
  def rules
  end

end

