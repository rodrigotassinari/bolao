class Bet < ActiveRecord::Base

  validates_presence_of :user_id, :game_id, :goals_a, :goals_b, :points #, :winner_id, :loser_id # TODO

  validates_inclusion_of :penalty, :tie, :in => [true, false]

  protected

end
