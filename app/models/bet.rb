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
  
  validates_presence_of :goals_a
  
  validates_presence_of :goals_b
  
  validates_presence_of :points
  
  #validates_presence_of :winner_id # TODO ?
  
  #validates_presence_of :loser_id # TODO ?
  
  validates_inclusion_of :penalty, :in => [true, false]
  
  validates_inclusion_of :tie, :in => [true, false]
  
  # Callbacks
  
  before_save :figure_out_winner_and_loser
  
  # Methods
  
  def self.find_or_initialize_for(user, game)
    bet = Bet.find_by_user_id_and_game_id(user.id, game.id)
    return bet unless bet.nil?
    bet = Bet.new(:user => user, :game => game)
    bet
  end
  
  protected
  
    # before_save
    def figure_out_winner_and_loser
      # TODO copiar de Game
    end
  
end

