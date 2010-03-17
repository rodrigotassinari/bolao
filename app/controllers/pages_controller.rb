class PagesController < ApplicationController

  def index
    @games_count = Game.count
    @users_count = User.count
    @paid_users_count = User.paid.count
    @bets_count = Bet.count
    @possible_bets_count = @users_count * @games_count
    @points_count = Bet.sum(:points)
    @total_prize = Bet.prize
    @potential_prize = Bet.potential_prize
    
    respond_to do |format|
      format.html   # index.html.erb
      format.iphone # index.iphone.erb
    end
  end
  
  def rules
  end

end

