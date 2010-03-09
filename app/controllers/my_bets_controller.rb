class MyBetsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /my_bet
  def show
    @user = current_user
    suborder = params[:order] || 'ASC'
    @games = Game.all(:order => "played_at #{suborder}")

    respond_to do |format|
      format.html # show.html.erb
    end
  end

end

