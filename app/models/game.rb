class Game < ActiveRecord::Base

  # Constants
  
  STAGES = ['Grupos', 'Oitavas', 'Quartas', 'Semis', 'Finais']
  
  # Options
  
  #attr_accessible :stadium, :city, :played_at, :team_a_id, :team_b_id, :goals_a, :goals_b, :stage, :penalty_goals_a, :penalty_goals_b # TODO
  
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
  
  validates_inclusion_of :penalty, :in => [true, false]
  
  validates_inclusion_of :tie, :in => [true, false]

  validates_presence_of :winner_id, :if => Proc.new { |game| game.played? && !game.tie? }
  
  validates_presence_of :loser_id, :if => Proc.new { |game| game.played? && !game.tie? }

  validates_presence_of :penalty_goals_a, :penalty_goals_b, :if => Proc.new { |game| game.played? && game.penalty? }
  
  validates_presence_of :goals_a, :goals_b, :if => Proc.new { |game| game.played? }

  validate :teams_must_be_different

  validate :teams_must_be_on_the_same_group, :if => Proc.new { |game| game.group_game? }
  
  validate :penalty_must_have_winner, :if => Proc.new { |game| game.played? && game.penalty? }

  # Callbacks

  before_validation :figure_out_winner_and_loser
  
  # TODO testar
  after_save :score_bets!, :if => Proc.new { |game| game.played? && game.has_goals? }
  
  # Scopes
  
  named_scope :bet_ordered, :order => "games.played_at ASC"
  
  # Methods
  
  # TOSPEC
  def bettable?
    !played? && Time.current < Game.minimum(:played_at, :conditions => {:stage => self.stage})
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
  def score_bets!
    bets = self.bets.all
    bets.each do |bet|
      bet.score!
    end
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
    # TOSPEC
    def teams_must_be_different
      if team_a_id == team_b_id
        errors.add_to_base("Times devem ser diferentes entre si")
      end
    end

    # validate
    # TOSPEC
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

    # before_validation
    # TODO: optimize
    # TOSPEC
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
              else
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

