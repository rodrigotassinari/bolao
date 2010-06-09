class BonusBetsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]

  # GET /bonus_bets
  # GET /bonus_bets.xml
  # TODO
  def index
    @bonus_bets = BonusBet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bonus_bets }
    end
  end

  # GET /bonus_bets/1
  # GET /bonus_bets/1.xml
  # TODO
  def show
    @bonus_bet = BonusBet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bonus_bet }
    end
  end

  # POST /bonus_bets
  # POST /bonus_bets.xml
  def create
    @bonus_bet = BonusBet.new(params[:bonus_bet])

    respond_to do |format|
      if @bonus_bet.save
        format.js { render :action => 'update_bonus_bet' } # update_bonus_bet.js.rjs
        format.iphone_js { render :action => 'update_bonus_bet.js.rjs' }
      else
        format.js { render :action => 'update_bonus_bet' }
        format.iphone_js { render :action => 'update_bonus_bet.js.rjs' }
      end
    end
  end

  # PUT /bonus_bets/1
  # PUT /bonus_bets/1.xml
  def update
    @bonus_bet = BonusBet.find(params[:id])

    respond_to do |format|
      if @bonus_bet.update_attributes(params[:bonus_bet])
        format.js { render :action => 'update_bonus_bet' } # update_bonus_bet.js.rjs
        format.iphone_js { render :action => 'update_bonus_bet.js.rjs' }
      else
        format.js { render :action => 'update_bonus_bet' }
        format.iphone_js { render :action => 'update_bonus_bet.js.rjs' }
      end
    end
  end

end
