class Game < ActiveRecord::Base

  # Constants
  
  STAGES = ['Grupos', 'Oitavas', 'Quartas', 'Semis', 'Finais']
  
  # Options
  
  attr_accessible :stadium, :city, :played_at, :team_a_id, :team_a, :team_b_id, :team_b, :goals_a, :goals_b, :stage, :penalty_goals_a, :penalty_goals_b
  
  # Associations
  
  has_many :bets, :dependent => :destroy

  belongs_to :team_a, :class_name => "Team"
  belongs_to :team_b, :class_name => "Team"

  belongs_to :winner, :class_name => "Team"
  belongs_to :loser,  :class_name => "Team"
  
  # Validations
  
  validates_presence_of :stage
  validates_inclusion_of :stage, :in => STAGES
  
  validates_presence_of :played_at
  
  validates_numericality_of :goals_a, :goals_b, :penalty_goals_a, :penalty_goals_b, 
    :allow_blank => true,
    :only_integer => true,
    :greater_than_or_equal_to => 0
  
  validates_presence_of :team_a_id
  
  validates_presence_of :team_b_id
  
  validates_inclusion_of :penalty, :tie, 
    :in => [true, false],
    :if => Proc.new { |game| game.has_goals? }
  
  validates_presence_of :winner_id, :if => Proc.new { |game| game.played? && !game.tie? }
  
  validates_presence_of :loser_id, :if => Proc.new { |game| game.played? && !game.tie? }

  validates_presence_of :penalty_goals_a, :penalty_goals_b, :if => Proc.new { |game| game.played? && game.penalty? }
  
  validates_presence_of :goals_a, :goals_b, :if => Proc.new { |game| game.played? }

  validate :teams_must_be_different

  validate :teams_must_be_on_the_same_group, :if => Proc.new { |game| game.group_game? }
  
  validate :penalty_must_have_winner, :if => Proc.new { |game| game.played? && game.penalty? }

  # Callbacks

  before_validation :figure_out_winner_and_loser
  
  after_save :score_bets!, :if => Proc.new { |game| game.played? && game.has_goals? }
  
  after_create :send_emails
  
  # Scopes
  
  named_scope :bet_ordered, :order => "games.played_at ASC"
  
  # Methods

  def next
    self.class.find :first,
      :conditions => ['id > ?', self.id],
      :order => 'id ASC'
  end

  def previous
    self.class.find :first,
      :conditions => ['id < ?', self.id],
      :order => 'id DESC'
  end
  
  def to_param
    "#{id}-#{team_a.acronym}-vs-#{team_b.acronym}"
  end
  
  # TOSPEC
  def bet_limit_date
    Game.minimum(:played_at, :conditions => {:stage => self.stage})
  end
  
  # TOSPEC
  def bettable?
    !played? && Time.current < bet_limit_date
  end
  
  # TOSPEC
  def group_game?
    stage == 'Grupos'
  end

  # TOSPEC
  def played?
    return false if self.played_at.nil?
    Time.current >= self.played_at
  end
  
  # TOSPEC
  def has_goals?
    goals_a && goals_b
  end
  
  # TOSPEC
  def has_penalty_goals?
    penalty_goals_a && penalty_goals_b
  end
  
  def score_bets!
    bets = self.bets.all
    bets.each do |bet|
      bet.score!
    end
    true
  end
  
  # TOSPEC
  def description
    "#{team_a.name} #{goals_a} x #{goals_b} #{team_b.name}, #{played_at.strftime('%d/%m %H:%M')} (#{stage})"
  end

  # TOSPEC
  def short_description
    "##{id} - #{team_a.acronym} #{goals_a} x #{goals_b} #{team_b.acronym}"
  end

  # TOSPEC
  def self.ids_for_history
    Game.all(
      :select => 'id',
      :order => 'id ASC',
      :conditions => 'goals_a IS NOT NULL AND goals_b IS NOT NULL'
    ).map(&:id) + ['total']
  end
  
  def self.all_by_stage_and_groups(stages=Game.stages, groups=Team.groups, order="games.played_at ASC", scope="1=1")
    games = {}
    stages.each do |stage|
      with_scope(:find => {:conditions => scope}) do
        if stage == 'Grupos'
          games[stage] = Game.all(
            :order => "teams.group ASC, #{order}", 
            :conditions => {:stage => stage},
            :include => [:team_a]
          )
        else
          games[stage] = Game.all(
            :order => order, 
            :conditions => {:stage => stage}
          )
        end
      end
    end
    games
  end
  
  def self.stages
    STAGES
  end
  
  def self.stadiums
    [
      nil,
      "Free State Stadium",
      "Cape Town Stadium",
      "Moses Mabhida Stadium",
      "Soccer City",
      "Ellis Park Stadium",
      "Mbombela Stadium",
      "Peter Mokaba Stadium",
      "Nelson Mandela Bay Stadium",
      "Loftus Versfeld Stadium",
      "Royal Bafokeng Stadium"
    ]
  end
  
  def self.cities
    [
      nil,
      "Bloemfontein",
      "Cidade do Cabo",
      "Durban",
      "Joanesburgo",
      "Nelspruit",
      "Polokwane",
      "Porto Elizabeth",
      "Pretória",
      "Rustenburgo"
    ]
  end

  protected

    # validate
    def teams_must_be_different
      if team_a_id == team_b_id
        errors.add_to_base("Times devem ser diferentes entre si")
      end
    end

    # validate
    def teams_must_be_on_the_same_group
      if team_a_id && team_b_id && group_game?
        errors.add_to_base("Times devem ser do mesmo grupo") if team_a.group != team_b.group
      end
    end
    
    # validate
    # TOSPEC
    def penalty_must_have_winner
      if penalty_goals_a && penalty_goals_b
        errors.add_to_base("Deve haver um vencedor na disputa de pênaltis") if penalty_goals_a == penalty_goals_b
      end
    end
    
    # TOSPEC
    # after_create
    def send_emails
      users = User.all(:select => 'id')
      users.each do |user|
        Resque.enqueue(MailJob, 'GamesMailer', 'deliver_available_to_bet', {'user_id' => user.id, 'game_id' => self.id})
      end
      true
    end
    
    # before_validation
    # TODO: optimize
    def figure_out_winner_and_loser
      if self.goals_a && self.goals_b
        if self.group_game?
          self.penalty = false
          if self.goals_a > self.goals_b
            self.winner_id = self.team_a_id
            self.loser_id  = self.team_b_id
            self.tie = false
          elsif self.goals_a < self.goals_b
            self.winner_id = self.team_b_id
            self.loser_id  = self.team_a_id
            self.tie = false
          else
            self.winner_id = nil
            self.loser_id  = nil
            self.tie = true
          end
        else
          if self.goals_a > self.goals_b
            self.winner_id = self.team_a_id
            self.loser_id  = self.team_b_id
            self.tie = false
            self.penalty = false
            self.penalty_goals_a = nil
            self.penalty_goals_b = nil
          elsif self.goals_a < self.goals_b
            self.winner_id = self.team_b_id
            self.loser_id  = self.team_a_id
            self.tie = false
            self.penalty = false
            self.penalty_goals_a = nil
            self.penalty_goals_b = nil
          else
            self.tie = false
            self.penalty = true
            if self.penalty_goals_a && self.penalty_goals_b
              if self.penalty_goals_a > self.penalty_goals_b
                self.winner_id = self.team_a_id
                self.loser_id  = self.team_b_id
              elsif self.penalty_goals_a < self.penalty_goals_b
                self.winner_id = self.team_b_id
                self.loser_id  = self.team_a_id
              end
            end
          end
        end
      end
      true
    end
      
end
