class User < ActiveRecord::Base
  
  # Options
  
  # Include default devise modules. Others available are:
  # :confirmable, :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :authenticatable, :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation
  
  # Associations
  
  has_many :bets, :dependent => :destroy
  has_many :bonus_bets, :dependent => :destroy
  has_many :comments

  # Validations
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # Scopes
  
  named_scope :by_points, :order => 'users.points_cache DESC, users.name ASC'

  named_scope :by_name, :order => 'users.name ASC'

  named_scope :paid, :conditions => 'users.paid_at IS NOT NULL AND users.payment_code IS NOT NULL AND users.payment_transaction_code IS NOT NULL'
  
  # Methods

  def next
    self.class.find :first,
      :conditions => ['id <> ? AND points_cache <= ? AND name >= ?', self.id, self.points_cache, self.name],
      :order => 'users.points_cache DESC, users.name ASC'
  end

  def previous
    self.class.find :first,
      :conditions => ['id <> ? AND points_cache >= ? AND name <= ?', self.id, self.points_cache, self.name],
      :order => 'users.points_cache DESC, users.name ASC'
  end
  
  def to_param
    "#{id}-#{email.split('@').first.parameterize}"
  end
  
  # TOSPEC
  def has_bets?
    bets.count > 0
  end

  # TOSPEC
  def has_bonus_bets?
    bonus_bets.count > 0
  end
  
  # TOSPEC
  def paid?
    !paid_at.nil? && 
      !payment_code.nil? && 
      !payment_transaction_code.nil?
  end
  
  # TOSPEC
  def paying?
    paid_at.nil? && 
      !payment_code.nil? && 
      !payment_transaction_code.nil?
  end

  # TOSPEC
  def all_betted?
    bets_kount = bets.count
    bonus_bets_kount = bonus_bets.count
    games_kount = Game.count
    bonus_kount = Bonus.count
    (bets_kount + bonus_bets_kount) == (games_kount + bonus_kount)
  end
  
  def update_points_cache!
    bets_points = self.bets.sum(:points)
    bonus_bets_points = self.bonus_bets.sum(:points)
    self.points_cache = bets_points + bonus_bets_points
    self.save!
  end

  def points_for_history(game_ids)
    points = []
    integer_game_ids = game_ids.last == 'total' ? game_ids[0..-2] : game_ids
    all_bets = self.bets.all(
      :select => 'game_id, points',
      :order => 'game_id ASC',
      :conditions => ['game_id in (?)', integer_game_ids]
    )
    game_ids.each do |game_id|
      if game_id.is_a?(Integer)
        subpoint = 0
        (1..game_id).to_a.each do |i|
          next if all_bets[i - 1].nil?
          subpoint += all_bets[i - 1].points.nil? ? 0 : all_bets[i - 1].points
        end
        points << subpoint
      else
        points << self.points_cache
      end
    end
    points
  end
  
end
