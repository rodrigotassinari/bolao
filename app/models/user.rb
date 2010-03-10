class User < ActiveRecord::Base
  
  # Options
  
  # Include default devise modules. Others available are:
  # :confirmable, :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :authenticatable, :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation
  
  # Associations
  
  has_many :bets
  
  # Validations
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # Methods
  
  def has_bets?
    bets.count > 0
  end
  
  def paid?
    !paid_at.nil?
  end
  
end

