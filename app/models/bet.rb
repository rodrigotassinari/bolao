class Bet < ActiveRecord::Base
  
  # Options
  
  #attr_accessible :game_id, :goals_a, :goals_b, :penalty, :penalty_goals_a, :penalty_goals_b, :tie # TODO
  
  # Associations
  
  belongs_to :user

  belongs_to :game

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
  
  validates_presence_of :points
  
  validates_presence_of :winner_id, :unless => Proc.new { |bet| bet.tie? }
  
  validates_presence_of :loser_id, :unless => Proc.new { |bet| bet.tie? }
  
  validates_inclusion_of :penalty, :in => [true, false]
  
  validates_inclusion_of :tie, :in => [true, false]
  
  validate :penalty_must_have_winner #, :if => Proc.new { |bet| bet.penalty? }
  
  # Callbacks
  
  before_validation :figure_out_winner_and_loser
  
  # Methods
  
  def locked?
    !game.bettable?
  end
  
  def self.find_or_initialize_for(user, game)
    bet = Bet.find_by_user_id_and_game_id(user.id, game.id)
    return bet unless bet.nil?
    bet = Bet.new(:user => user, :game => game)
    bet
  end
  
  protected
  
    # validate
    def penalty_must_have_winner
      if penalty_goals_a && penalty_goals_b
        if penalty_goals_a == penalty_goals_b
          errors.add(:penalty_goals_a, "Deve haver um vencedor na disputa de pênaltis")
          errors.add(:penalty_goals_b, "Deve haver um vencedor na disputa de pênaltis")
        end
      end
    end
  
    # before_validation
    # TODO: optimize
    # TOSPEC
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
              else
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

