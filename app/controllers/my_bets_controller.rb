class MyBetsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /my_bet
  def show
    @user = current_user
    @games = Game.all(:order => 'played_at ASC')

    respond_to do |format|
      format.html # show.html.erb
    end
  end

end

