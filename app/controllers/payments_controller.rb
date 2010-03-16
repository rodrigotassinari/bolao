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
  def done
    if request.post?
      pagseguro_notification do |notification|
        raise unless notification.valid?
        user = User.find_by_payment_code(notification.params["Referencia"]) || User.find_by_email(notification.buyer[:email])
        raise if user.nil?
        user.update_attribute(:payment_transaction_code, notification.params["TransacaoID"])
        case notification.status
        when :completed
          user.update_attribute(:paid_at, Time.current)
        when :approved
          user.update_attribute(:paid_at, Time.current)
        else
          user.update_attribute(:paid_at, nil)
        end
      end
      render :nothing => true
    end
  end
  
end

