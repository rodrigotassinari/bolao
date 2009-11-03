class Game < ActiveRecord::Base

  has_many :bets

  belongs_to :team_a, :class_name => "Team"
  belongs_to :team_b, :class_name => "Team"

  belongs_to :winner, :class_name => "Team"
  belongs_to :loser,  :class_name => "Team"

  #attr_accessible :stadium, :city, :played_at, :team_a_id, :team_b_id, :goals_a, :goals_b, :group_game, :penalty, :tie

  validates_presence_of :stadium, :city, :played_at, :team_a_id, :team_b_id

  validates_inclusion_of :group_game, :penalty, :tie, :in => [true, false]

  validates_presence_of :winner_id, :loser_id, :if => Proc.new { |game| game.played? && !game.tie? }

  validates_presence_of :penalty_goals_a, :penalty_goals_b, :if => Proc.new { |game| game.played? && game.penalty? }

  def played?
    return false if self.played_at.nil?
    Time.current >= self.played_at
  end

  validate :teams_must_be_different
  validate :teams_must_be_on_the_same_group, :if => Proc.new { |game| game.group_game? }

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

end
