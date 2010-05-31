class PaymentsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => [:done]
  before_filter :authenticate_user!, :except => [:done]
  
  # GET /payment/new
  def new
    @user = current_user
    if @user.paid?
      redirect_to payment_path
    else
      @payment_code = Digest::SHA1.hexdigest("#{@user.id}--#{@user.email}")
      @user.update_attribute(:payment_code, @payment_code)
      @order = PagSeguro::Order.new(@payment_code)
      @order.add(
        :id => 'Aposta no Bolao', 
        :description => "Aposta no Bolao PiTTlandia Copa 2010, por #{@user.email}", 
        :price => Bet.full_value, 
        :quantity => 1,
        :weight => 0.0, 
        :shipping => 0.0,
        :fees => 0.0,
        :shipping_type => "FR"
      )
    end
  end
  
  # GET /payment
  def show
  end
  
  # GET /payment/done
  # Funciona em development, funciona em production na máquina local mas não funfa em produção! PQ???
  def done
    if request.post?
logger.warn ">>> entrou no post"
      pagseguro_notification do |notification|
logger.warn ">>> entrou no notification"
        raise unless notification.valid?
logger.warn ">>> válido"
logger.warn ">>> dados do post: Referencia = #{notification.params["Referencia"]}, TransacaoID = #{notification.params["TransacaoID"]}, StatusTransacao = #{notification.params["StatusTransacao"]}"
logger.warn ">>> status parseado do post: #{notification.status}"
        user = User.find_by_payment_code(notification.params["Referencia"]) || User.find_by_email(notification.buyer[:email])
        raise if user.nil?
logger.warn ">>> achou user: id = #{user.id}, nome = #{user.name}, payment_code = #{user.payment_code}"
logger.warn ">>> ANTES: payment_transaction_code = #{user.payment_transaction_code}, paid_at = #{user.paid_at}"
        user.update_attribute(:payment_transaction_code, notification.params["TransacaoID"])
        user.update_attribute(:paid_at, nil)
        user.update_attribute(:paid_at, Time.current) if notification.status == :completed
        user.update_attribute(:paid_at, Time.current) if notification.status == :approved
        user.update_attribute(:paid_at, Time.current) if notification.params["StatusTransacao"] == "Completo"
        user.update_attribute(:paid_at, Time.current) if notification.params["StatusTransacao"] == "Aprovado"
logger.warn ">>> DEPOIS: payment_transaction_code = #{user.payment_transaction_code}, paid_at = #{user.paid_at}"
        user.reload
logger.warn ">>> RELOAD: payment_transaction_code = #{user.payment_transaction_code}, paid_at = #{user.paid_at}"
      end
      render :nothing => true
logger.warn ">>> final, renderiza nada"
    end
  end
  
end
