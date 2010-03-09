class Game < ActiveRecord::Base

  # Constants
  
  STAGES = ['Grupos', 'Oitavas', 'Quartas', 'Semis', 'Finais']
  
  # Options
  
  #attr_accessible :stadium, :city, :played_at, :team_a_id, :team_b_id, :goals_a, :goals_b, :group_game, :penalty # TODO
  
  # Associations
  
  has_many :bets

  belongs_to :team_a, :class_name => "Team"
  belongs_to :team_b, :class_name => "Team"

  belongs_to :winner, :class_name => "Team"
  belongs_to :loser,  :class_name => "Team"
  
  # Validations
  
  validates_presence_of :stage
  validates_inclusion_of :stage, :in => STAGES
  
  validates_presence_of :played_at
  
  #validates_presence_of :team_a_id
  
  #validates_presence_of :team_b_id
  
  validates_inclusion_of :penalty, :in => [true, false]
  
  validates_inclusion_of :tie, :in => [true, false]

  validates_presence_of :winner_id, :if => Proc.new { |game| game.played? && !game.tie? }
  
  validates_presence_of :loser_id, :if => Proc.new { |game| game.played? && !game.tie? }

  validates_presence_of :penalty_goals_a, :if => Proc.new { |game| game.played? && game.penalty? }
  
  validates_presence_of :penalty_goals_b, :if => Proc.new { |game| game.played? && game.penalty? }

  validate :teams_must_be_different

  validate :teams_must_be_on_the_same_group, :if => Proc.new { |game| game.group_game? }

  # Callbacks

  before_validation :figure_out_winner_and_loser
  
  # Scopes
  
  named_scope :bet_ordered, :order => "games.played_at ASC"
  
  # Methods
  
  def group_game?
    stage == 'Grupos'
  end

  def played?
    return false if self.played_at.nil?
    Time.current >= self.played_at
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

    # before_validation
    # TODO: optimize
    def figure_out_winner_and_loser
      if self.goals_a && self.goals_b
        if self.group_game?
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
          elsif self.goals_a < self.goals_b
            self.winner_id = self.team_b_id
            self.loser_id  = self.team_a_id
            self.tie = false
          else
            self.tie = false
            if self.penalty? && self.penalty_goals_a && self.penalty_goals_b
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

