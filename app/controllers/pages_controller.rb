class PagesController < ApplicationController

  def index
    @games_count = Game.count
    @users_count = User.count
    @paid_users_count = User.paid.count
    @bets_count = Bet.count
    @possible_bets_count = @users_count * @games_count
    @points_count = Bet.sum(:points)
    @total_prize = Bet.prize
  end
  
  def rules
  end

end

