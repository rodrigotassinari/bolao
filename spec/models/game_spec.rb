require 'spec_helper'

describe Game do
  fixtures :games, :teams
  
  before(:each) do
    @valid_attributes = {
      :stadium => "Engenhão",
      :city => "Rio de Janeiro",
      :played_at => 4.months.from_now,
      :group_game => true,
      :team_a_id => teams(:bra).id,
      :team_b_id => teams(:aus).id,
      :goals_a => 1,
      :goals_b => 2,
      :penalty => false
    }
  end

  it "should create a new instance given valid attributes" do
    game = Game.new(@valid_attributes)
    game.should be_valid
    #Game.create!(@valid_attributes)
  end

  # validando as fixtures, pois são bem complexas
  describe "fixtures" do
    Game.all.each do |game|
      it "should be valid: #{game.played_at}" do
        game.should be_valid
      end
    end
  end

  # Associações

  it { should have_many(:bets) }

  it { should belong_to(:team_a, :class_name => "Team") }
  it { should belong_to(:team_b, :class_name => "Team") }

  it { should belong_to(:winner, :class_name => "Team") }
  it { should belong_to(:loser,  :class_name => "Team") }

  # Validações

  it { should validate_presence_of(:stadium, :city, :played_at, :team_a_id, :team_b_id) }

  it { should validate_inclusion_of(:group_game, :penalty, :tie, :in => [true, false]) }

#  subject { Game.new(@valid_attributes.merge(:tie => false, :played_at => 2.days.ago)) }
#  it {
#    subject.should_not be_tie
#    subject.should be_played
#    should validate_presence_of(:winner_id, :loser_id)
#  }

  subject { Game.new(@valid_attributes.merge(:penalty => true, :played_at => 2.days.ago)) }
  it {
    subject.should be_penalty
    subject.should be_played
    should validate_presence_of(:penalty_goals_a, :penalty_goals_b)
  }

  it "should validate that teams are not the same" do
    game = Game.new(@valid_attributes.merge(:team_a_id => teams(:bra).id, :team_b_id => teams(:bra).id))
    game.should_not be_valid
    game.should have(1).error_on(:base)
  end

  it "should validate that teams are from the same group if it is a group game" do
    t1 = teams(:bra)
    t2 = teams(:fra)
    t1.group.should_not == t2.group
    game = Game.new(@valid_attributes.merge(:team_a_id => t1.id, :team_b_id => t2.id, :group_game => true))
    game.should_not be_valid
    game.should have(1).error_on(:base)
  end
  it "should allow teams from different groups if it is not a group game" do
    t1 = teams(:bra)
    t2 = teams(:fra)
    t1.group.should_not == t2.group
    game = Game.new(@valid_attributes.merge(:team_a_id => t1.id, :team_b_id => t2.id, :group_game => false))
    game.should be_valid
    game.should have(:no).error_on(:base)
  end

  # Defaults

  describe "should figure out the winner and loser automagically" do
    context "in group games" do
      before(:each) do
        @game = Game.new(@valid_attributes.merge(:group_game => true))
      end
      it "when team A wins" do
        @game.goals_a = 2
        @game.goals_b = 1
        @game.penalty = false
        @game.save!
        @game.reload
        @game.should_not be_tie
        @game.winner_id.should == @game.team_a_id
        @game.loser_id.should == @game.team_b_id
      end
      it "when team B wins" do
        @game.goals_a = 1
        @game.goals_b = 2
        @game.penalty = false
        @game.save!
        @game.reload
        @game.should_not be_tie
        @game.winner_id.should == @game.team_b_id
        @game.loser_id.should == @game.team_a_id
      end
      it "when it's a tie" do
        @game.goals_a = 1
        @game.goals_b = 1
        @game.penalty = false
        @game.save!
        @game.reload
        @game.should be_tie
        @game.winner_id.should be_nil
        @game.loser_id.should be_nil
      end
    end
    context "in final games" do
      before(:each) do
        @game = Game.new(@valid_attributes.merge(:group_game => false))
      end
      it "when team A wins a final game" do
        @game.goals_a = 2
        @game.goals_b = 1
        @game.penalty = false
        @game.save!
        @game.reload
        @game.should_not be_tie
        @game.winner_id.should == @game.team_a_id
        @game.loser_id.should == @game.team_b_id
      end
      it "when team B wins a final game" do
        @game.goals_a = 1
        @game.goals_b = 2
        @game.penalty = false
        @game.save!
        @game.reload
        @game.should_not be_tie
        @game.winner_id.should == @game.team_b_id
        @game.loser_id.should == @game.team_a_id
      end
      it "when team A wins a final game on penaltys" do
        @game.goals_a = 1
        @game.goals_b = 1
        @game.penalty = true
        @game.penalty_goals_a = 4
        @game.penalty_goals_b = 3
        @game.save!
        @game.reload
        @game.should_not be_tie
        @game.winner_id.should == @game.team_a_id
        @game.loser_id.should == @game.team_b_id
      end
      it "when team B wins a final game on penaltys" do
        @game.goals_a = 1
        @game.goals_b = 1
        @game.penalty = true
        @game.penalty_goals_a = 3
        @game.penalty_goals_b = 4
        @game.save!
        @game.reload
        @game.should_not be_tie
        @game.winner_id.should == @game.team_b_id
        @game.loser_id.should == @game.team_a_id
      end
    end
  end

  # Métodos

  describe ".played?" do
    before(:each) do
      @game = Game.new(@valid_attributes)
    end
    it "should return false if the game's date is after now" do
      @game.played_at = 2.days.from_now
      @game.should_not be_played
    end
    it "should return true if the game's date is now" do
      @game.played_at = Time.current
      @game.should be_played
    end
    it "should return true if the game's date before now" do
      @game.played_at = 2.days.ago
      @game.should be_played
    end
  end

end
