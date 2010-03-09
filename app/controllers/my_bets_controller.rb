class MyBetsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /my_bet
  # GET /my_bet.xml
  def show
    @user = current_user
    @games = Game.order('played_at ASC').all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bet }
    end
  end

end

