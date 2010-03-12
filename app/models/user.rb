class User < ActiveRecord::Base
  
  # Options
  
  # Include default devise modules. Others available are:
  # :confirmable, :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :authenticatable, :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation
  
  # Associations
  
  has_many :bets, :dependent => :destroy
  
  # Validations
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # Scopes
  
  named_scope :by_points, :order => 'users.points_cache DESC, users.name ASC'
  
  named_scope :paid, :conditions => 'users.paid_at IS NOT NULL AND users.payment_code IS NOT NULL'
  
  # Methods
  
  # TOSPEC
  def has_bets?
    bets.count > 0
  end
  
  # TOSPEC
  def paid?
    !paid_at.nil? && !payment_code.nil?
  end
  
  def update_points_cache!
    self.points_cache = self.bets.sum(:points)
    self.save!
  end
  
end

