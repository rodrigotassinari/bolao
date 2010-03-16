require 'spec_helper'

describe Bet do
  fixtures :teams, :games, :bets, :users
  
  before(:each) do
    @valid_attributes = {
      :game => games(:finals_unplayed),
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
      it "should have valid fixture: #{bet.description}" do
        bet.should be_valid
      end
    end
  end
  
  describe "figure_out_winner_and_loser" do
    before(:each) do
      @user = users(:admin)
      @bet = Bet.new(:user => @user)
    end
    context "group games" do
      before(:each) do
        @game = games(:group_unplayed)
        @game.should be_group_game
        @game.stub(:bettable?).and_return(true) # MARRETA!
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
  
  describe ".calculate_points" do
    it "should return nil if bet's game has not been played yet" do
      bet = bets(:five)
      bet.game.should_not be_played
      bet.calculate_points.should be_nil
    end
    it "should return nil if bet's game has not been scored yet" do
      bet = bets(:five)
      bet.game.should_not have_goals
      bet.calculate_points.should be_nil
    end
    context "group games" do
      context "simple win" do
        before(:each) do
          @bet = bets(:one)
          @game = @bet.game
          @game.should be_group_game
          @game.should be_played
          @game.should have_goals
          @game.should_not be_tie
        end
        it "should give 0 points if nothing is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 0
          @bet.winner_id = nil
          @bet.loser_id = nil
          @bet.calculate_points.should == 0
        end
        it "should give 4 points if everything is right" do
          @bet.winner_id = @game.winner.id
          @bet.loser_id = @game.loser.id
          @bet.goals_a = @game.goals_a
          @bet.goals_b = @game.goals_b
          @bet.calculate_points.should == 4
        end
        it "should give 2 points if winner (and loser) is right" do
          @bet.winner_id = @game.winner.id
          @bet.loser_id = @game.loser.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 2
        end
        it "should give 1 point if goals_a is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 1
        end
        it "should give 1 point if goals_b is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b
          @bet.calculate_points.should == 1
        end
      end
      context "tie" do
        before(:each) do
          @bet = bets(:three)
          @game = @bet.game
          @game.should be_group_game
          @game.should be_played
          @game.should have_goals
          @game.should be_tie
        end
        it "should give 0 points if nothing is right" do
          @bet.winner_id = 2
          @bet.loser_id = 4
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 0
        end
        it "should give 4 points if everything is right" do
          @bet.winner_id = nil
          @bet.loser_id = nil
          @bet.tie = true
          @bet.goals_a = @game.goals_a
          @bet.goals_b = @game.goals_b
          @bet.calculate_points.should == 4
        end
        it "should give 2 points if tie is right (tie was expected)" do
          @bet.winner_id = nil
          @bet.loser_id = nil
          @bet.should be_tie
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 2
        end
        it "should give 1 point if goals_a is right" do
          @bet.winner_id = @game.team_a.id
          @bet.loser_id = @game.team_b.id
          @bet.goals_a = @game.goals_a
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 1
        end
        it "should give 1 point if goals_b is right" do
          @bet.winner_id = @game.team_a.id
          @bet.loser_id = @game.team_b.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b
          @bet.calculate_points.should == 1
        end
      end
    end
    context "finals games" do
      context "simple win" do
        before(:each) do
          @bet = bets(:six)
          @game = @bet.game
          @game.should_not be_group_game
          @game.should be_played
          @game.should have_goals
          @game.should_not be_tie
        end
        it "should give 0 points if nothing is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 0
        end
        it "should give 6 points if everything is right" do
          @bet.winner_id = @game.winner.id
          @bet.loser_id = @game.loser.id
          @bet.goals_a = @game.goals_a
          @bet.goals_b = @game.goals_b
          @bet.calculate_points.should == 6
        end
        it "should give 4 points if winner (and loser) is right" do
          @bet.winner_id = @game.winner.id
          @bet.loser_id = @game.loser.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 4
        end
        it "should give 1 point if goals_a is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a
          @bet.goals_b = @game.goals_b + 1
          @bet.calculate_points.should == 1
        end
        it "should give 1 point if goals_b is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b
          @bet.calculate_points.should == 1
        end
      end
      context "penalty win" do
        before(:each) do
          @bet = bets(:four)
          @game = @bet.game
          @game.should_not be_group_game
          @game.should be_played
          @game.should have_goals
          @game.should have_penalty_goals
          @game.should_not be_tie
          @game.should be_penalty
        end
        it "should give 0 points if nothing is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.penalty_goals_a = @game.penalty_goals_a + 1
          @bet.penalty_goals_b = @game.penalty_goals_b + 1
          @bet.calculate_points.should == 0
        end
        it "should give 8 points if everything is right" do
          @bet.winner_id = @game.winner.id
          @bet.loser_id = @game.loser.id
          @bet.goals_a = @game.goals_a
          @bet.goals_b = @game.goals_b
          @bet.penalty = true
          @bet.penalty_goals_a = @game.penalty_goals_a
          @bet.penalty_goals_b = @game.penalty_goals_b
          @bet.calculate_points.should == 8
        end
        it "should give 4 points if winner (and loser) is right" do
          @bet.winner_id = @game.winner.id
          @bet.loser_id = @game.loser.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.penalty_goals_a = @game.penalty_goals_a + 1
          @bet.penalty_goals_b = @game.penalty_goals_b + 1
          @bet.calculate_points.should == 4
        end
        it "should give 1 point if goals_a is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a
          @bet.goals_b = @game.goals_b + 1
          @bet.penalty_goals_a = @game.penalty_goals_a + 1
          @bet.penalty_goals_b = @game.penalty_goals_b + 1
          @bet.calculate_points.should == 1
        end
        it "should give 1 point if goals_b is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b
          @bet.penalty_goals_a = @game.penalty_goals_a + 1
          @bet.penalty_goals_b = @game.penalty_goals_b + 1
          @bet.calculate_points.should == 1
        end
        it "should give 1 point if penalty_goals_a is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.penalty_goals_a = @game.penalty_goals_a
          @bet.penalty_goals_b = @game.penalty_goals_b + 1
          @bet.calculate_points.should == 1
        end
        it "should give 1 point if penalty_goals_b is right" do
          @bet.winner_id = @game.loser.id
          @bet.loser_id = @game.winner.id
          @bet.goals_a = @game.goals_a + 1
          @bet.goals_b = @game.goals_b + 1
          @bet.penalty_goals_a = @game.penalty_goals_a + 1
          @bet.penalty_goals_b = @game.penalty_goals_b
          @bet.calculate_points.should == 1
        end
      end
    end
  end
  
end

