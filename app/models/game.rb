class Game < ActiveRecord::Base

  #attr_accessible  :stadium, :city, :played_on, :team_a_id, :team_b_id, :goals_a, :goals_b, :group_game, :penalty, :tie

  validates_presence_of :stadium, :city, :played_on, :team_a_id, :team_b_id, :goals_a, :goals_b

  validates_inclusion_of :group_game, :penalty, :tie, :in => [true, false]

  validates_presence_of :winner_id, :loser_id, :unless => Proc.new { |game| game.tie? }

  validates_presence_of :penalty_goals_a, :penalty_goals_b, :if => Proc.new { |game| game.penalty? }

end
