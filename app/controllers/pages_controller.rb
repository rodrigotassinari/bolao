class PagesController < ApplicationController

  before_filter :authenticate_user!, :only => [:invite]
  before_filter :require_admin!, :only => [:invite]

  def index
    @games_count = Game.count
    @users_count = User.count
    @bonus_count = Bonus.count
    @paid_users_count = User.paid.count
    @bets_count = Bet.count
    @bonus_bets_count = BonusBet.count
    @possible_bets_count = @users_count * @games_count
    @possible_bonus_bets_count = @users_count * @bonus_count
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

  def invite
    if request.post?
      if params[:name].present? && params[:email].present?
        Resque.enqueue(MailJob, 'AdminMailer', 'deliver_ask_to_join', {'name' => params[:name], 'email' => params[:email]})
        flash[:notice] = "Email enviado."
      else
        flash[:error] = "Dados incompletos, email NÃO foi enviado."
      end
      redirect_to invite_path
    end
  end

end
