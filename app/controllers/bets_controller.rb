class BetsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show]
  
  # GET /bets
  # GET /bets.xml
  # TODO
  def index
    @bets = Bet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bets }
    end
  end

  # GET /bets/1
  # GET /bets/1.xml
  # TODO
  def show
    @bet = Bet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bet }
    end
  end

  # POST /bets
  # POST /bets.xml
  def create
    @bet = Bet.new(params[:bet])
    
    respond_to do |format|
      if @bet.save
        format.js { render :action => 'update_bet' } # update_bet.js.rjs
      else
        format.js { render :action => 'update_bet' }
      end
    end
  end

  # PUT /bets/1
  # PUT /bets/1.xml
  def update
    @bet = Bet.find(params[:id])
    
    respond_to do |format|
      if @bet.update_attributes(params[:bet])
        format.js { render :action => 'update_bet' }
      else
        format.js { render :action => 'update_bet' }
      end
    end
  end

end

