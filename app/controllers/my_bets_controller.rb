class MyBetsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /my_bet
  def show
    @user = current_user
    
    suborder = params[:desc] ? 'DESC' : 'ASC'
    conditions = params[:empty] ? ['games.id NOT IN (?)', @user.bets.all(:select => 'game_id').map(&:game_id)] : "1=1"
    
    @stages = (suborder == 'ASC' ? Game.stages : Game.stages.reverse)
    @groups = Team.groups
    
    @games = Game.all_by_stage_and_groups(@stages, @groups, "games.played_at #{suborder}", conditions)
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  # POST /my_bet
  def create
    user = current_user
    Bet.create_random_bets_for!(user)
    flash[:success] = "Palpites aleatórios criados com sucesso."
    redirect_to my_bet_path
  end

end

