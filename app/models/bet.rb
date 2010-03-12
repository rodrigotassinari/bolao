class Bet < ActiveRecord::Base
  
  # Constants
  
  NET_VALUE = 20.0
  
  # Options
  
  attr_accessible :user_id, :user, :game_id, :game, :goals_a, :goals_b, :penalty_goals_a, :penalty_goals_b
  
  # Associations
  
  belongs_to :user, :counter_cache => true

  belongs_to :game, :counter_cache => true

  belongs_to :winning_team, :class_name => "Team", :foreign_key => "winner_id"
  belongs_to :losing_team,  :class_name => "Team", :foreign_key => "loser_id"
  
  # Validations
  
  validates_presence_of :user_id
  
  validates_presence_of :game_id
  
  validates_presence_of :goals_a, :goals_b
  
  validates_presence_of :penalty_goals_a, :penalty_goals_b, :if => Proc.new { |bet| bet.penalty? }
  
  validates_numericality_of :goals_a, :goals_b, :penalty_goals_a, :penalty_goals_b, 
    :allow_blank => true,
    :only_integer => true,
    :greater_than_or_equal_to => 0
  
  validates_presence_of :points, :unless => Proc.new { |bet| bet.scored_at.nil? }
  
  validates_presence_of :winner_id, :loser_id, :unless => Proc.new { |bet| bet.tie? }
  
  validates_inclusion_of :penalty, :tie, :in => [true, false]
  
  validate :penalty_must_have_winner #, :if => Proc.new { |bet| bet.penalty? }
  
  # Callbacks
  
  before_validation :figure_out_winner_and_loser
  
  after_save :update_user_points_cache
  
  # Methods
  
  # TOSPEC
  def locked?
    !game.bettable?
  end
  
  # TOSPEC
  def self.find_or_initialize_for(user, game)
    bet = Bet.find_by_user_id_and_game_id(user.id, game.id)
    return bet unless bet.nil?
    bet = Bet.new(:user => user, :game => game)
    bet
  end
  
  def calculate_points
    return unless self.game && self.game.played? && self.game.has_goals?
    score = if self.game.group_game?
      group_game_score
    else
      finals_game_score
    end
    score
  end
  
  # TOSPEC
  def score!
    self.scored_at = Time.current
    self.points = calculate_points
    save!
  end
  
  # TOSPEC
  def scored?
    self.points && !self.scored_at.nil?
  end
  
  protected
  
    def group_game_score
      score = 0
      score += 1 if self.winner_id == self.game.winner_id
      score += 1 if self.loser_id  == self.game.loser_id
      score += 1 if self.goals_a   == self.game.goals_a
      score += 1 if self.goals_b   == self.game.goals_b
      score
    end

    def finals_game_score
      score = 0
      score += 2 if self.winner_id == self.game.winner_id
      score += 2 if self.loser_id  == self.game.loser_id
      score += 1 if self.goals_a   == self.game.goals_a
      score += 1 if self.goals_b   == self.game.goals_b
      if !self.game.group_game? && self.game.penalty?
        score += 1 if self.penalty_goals_a == self.game.penalty_goals_a
        score += 1 if self.penalty_goals_b == self.game.penalty_goals_b
      end
      score
    end
  
    # validate
    # TOSPEC
    def penalty_must_have_winner
      if penalty_goals_a && penalty_goals_b
        if penalty_goals_a == penalty_goals_b
          errors.add(:penalty_goals_a, "Deve haver um vencedor na disputa de pênaltis")
          errors.add(:penalty_goals_b, "Deve haver um vencedor na disputa de pênaltis")
        end
      end
    end
    
    # after_save
    # TOSPEC
    def update_user_points_cache
      if self.user && self.scored?
        self.user.update_points_cache!
      end
      true
    end
  
    # before_validation
    # TODO: optimize
    def figure_out_winner_and_loser
      if self.goals_a && self.goals_b
        if self.game.group_game?
          self.penalty = false
          if self.goals_a > self.goals_b
            self.winner_id = self.game.team_a_id
            self.loser_id  = self.game.team_b_id
            self.tie = false
          elsif self.goals_a < self.goals_b
            self.winner_id = self.game.team_b_id
            self.loser_id  = self.game.team_a_id
            self.tie = false
          else
            self.winner_id = nil
            self.loser_id  = nil
            self.tie = true
          end
        else
          if self.goals_a > self.goals_b
            self.winner_id = self.game.team_a_id
            self.loser_id  = self.game.team_b_id
            self.tie = false
            self.penalty = false
            self.penalty_goals_a = nil
            self.penalty_goals_b = nil
          elsif self.goals_a < self.goals_b
            self.winner_id = self.game.team_b_id
            self.loser_id  = self.game.team_a_id
            self.tie = false
            self.penalty = false
            self.penalty_goals_a = nil
            self.penalty_goals_b = nil
          else
            self.tie = false
            self.penalty = true
            if self.penalty_goals_a && self.penalty_goals_b
              if self.penalty_goals_a > self.penalty_goals_b
                self.winner_id = self.game.team_a_id
                self.loser_id  = self.game.team_b_id
              elsif self.penalty_goals_a < self.penalty_goals_b
                self.winner_id = self.game.team_b_id
                self.loser_id  = self.game.team_a_id
              end
            end
          end
        end
      end
      true
    end
  
end

