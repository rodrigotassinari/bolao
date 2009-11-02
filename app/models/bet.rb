class Bet < ActiveRecord::Base

  belongs_to :user

  belongs_to :game

  belongs_to :winning_team, :class_name => "Team", :foreign_key => "winner_id"
  belongs_to :losing_team,  :class_name => "Team", :foreign_key => "loser_id"

  validates_presence_of :user_id, :game_id, :goals_a, :goals_b, :points #, :winner_id, :loser_id # TODO

  validates_inclusion_of :penalty, :tie, :in => [true, false]

  protected

end
