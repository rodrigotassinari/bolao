require 'spec_helper'

describe Bet do
  fixtures :teams, :games, :bets, :users
  
  before(:each) do
    @valid_attributes = {
      :game => games(:group_unplayed),
      :user => users(:user),
      :goals_a => 2,
      :goals_b => 1
    }
  end

  it "should create a new instance given valid attributes" do
    bet = Bet.new(@valid_attributes)
    bet.should be_valid
    bet.save!
  end
  
  describe "fixtures" do
    Bet.all.each do |bet|
      xit "should have valid fixture: #{bet.id}" do
        bet.should be_valid
      end
    end
  end
  
  describe "figure_out_winner_and_loser" do
    before(:each) do
      @user = users(:user)
      @bet = Bet.new(:user => @user)
    end
    context "group games" do
      before(:each) do
        @game = games(:group_unplayed)
        @game.should be_group_game
        @bet.game = @game
      end
      it "should set A as the winner" do
        @bet.goals_a = 2
        @bet.goals_b = 1
        @bet.save!
        @bet.winning_team.should == @game.team_a
        @bet.losing_team.should == @game.team_b
      end
      it "should set B as the winner" do
        @bet.goals_a = 1
        @bet.goals_b = 2
        @bet.save!
        @bet.winning_team.should == @game.team_b
        @bet.losing_team.should == @game.team_a
      end
      it "should set a tie" do
        @bet.goals_a = 1
        @bet.goals_b = 1
        @bet.save!
        @bet.winning_team.should be_nil
        @bet.losing_team.should be_nil
        @bet.should be_tie
        @bet.should_not be_penalty
      end
    end
    context "final games" do
      before(:each) do
        @game = games(:finals_unplayed)
        @game.should_not be_group_game
        @bet.game = @game
      end
      it "should set A as the winner" do
        @bet.goals_a = 2
        @bet.goals_b = 1
        @bet.save!
        @bet.winning_team.should == @game.team_a
        @bet.losing_team.should == @game.team_b
      end
      it "should set B as the winner" do
        @bet.goals_a = 1
        @bet.goals_b = 2
        @bet.save!
        @bet.winning_team.should == @game.team_b
        @bet.losing_team.should == @game.team_a
      end
      it "should set A as the winner via penaltys" do
        @bet.goals_a = 2
        @bet.goals_b = 2
        @bet.penalty_goals_a = 5
        @bet.penalty_goals_b = 3
        @bet.save!
        @bet.should_not be_tie
        @bet.should be_penalty
        @bet.winning_team.should == @game.team_a
        @bet.losing_team.should == @game.team_b
      end
      it "should set B as the winner via penaltys" do
        @bet.goals_a = 2
        @bet.goals_b = 2
        @bet.penalty_goals_a = 3
        @bet.penalty_goals_b = 5
        @bet.save!
        @bet.should_not be_tie
        @bet.should be_penalty
        @bet.winning_team.should == @game.team_b
        @bet.losing_team.should == @game.team_a
      end
      it "should not set a tie" do
        @bet.goals_a = 1
        @bet.goals_b = 1
        @bet.penalty_goals_a.should be_nil
        @bet.penalty_goals_b.should be_nil
        @bet.should_not be_valid
        @bet.should_not be_tie
        @bet.should be_penalty
      end
    end
  end
  
end

