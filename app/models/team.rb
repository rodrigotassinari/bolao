class Team < ActiveRecord::Base

  has_many :games_as_a, :class_name => "Game", :foreign_key => "team_a_id"
  has_many :games_as_b, :class_name => "Game", :foreign_key => "team_b_id"
  has_many :games, :class_name => "Game", :finder_sql => 'SELECT * FROM games WHERE (games.team_a_id = #{id} OR games.team_b_id = #{id})'

  has_many :winning_games, :class_name => "Game", :foreign_key => "winner_id"
  has_many :losing_games,  :class_name => "Game", :foreign_key => "loser_id"

  has_many :winning_bets, :class_name => "Bet", :foreign_key => "winner_id"
  has_many :losing_bets,  :class_name => "Bet", :foreign_key => "loser_id"
  has_many :bets, :class_name => "Bet", :finder_sql => 'SELECT * FROM bets WHERE (bets.winner_id = #{id} OR bets.loser_id = #{id})' # TODO trocar para has trough association?

  validates_presence_of :name, :acronym, :group

  validates_uniqueness_of :name, :acronym

end
