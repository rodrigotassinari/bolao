require 'spec_helper'

describe Game do
  fixtures :teams, :games, :bets
  
  before(:each) do
    @valid_attributes = {
      :played_at => Time.parse('2010-06-11 15:30'),
      :stage => 'Grupos',
      :team_a => teams(:bra),
      :team_b => teams(:por)
    }
  end

  it "should create a new instance given valid attributes" do
    game = Game.new(@valid_attributes)
    game.should be_valid
    game.save!
  end
  
  describe "fixtures" do
    Game.all.each do |game|
      it "should have valid fixture: #{game.id}" do
        game.should be_valid
      end
    end
  end
  
  it "should not allow the teams to be the same" do
    game = Game.new(@valid_attributes.with(:team_b => teams(:bra)))
    game.team_a.should == game.team_b
    game.should_not be_valid
    game.errors.full_messages.should include("Times devem ser diferentes entre si")
  end
  
  it "should score the related bets when fully filled and game has been played" do
    game = Game.new(@valid_attributes)
    game.goals_a = 1
    game.goals_b = 2
    game.played_at = 2.days.ago
    game.should be_played
    game.should have_goals
    game.should_receive :score_bets!
    game.save!
  end
  
  it "should not score the related bets until fully filled" do
    game = Game.new(@valid_attributes)
    game.goals_a.should be_nil
    game.goals_b.should be_nil
    game.played_at.should > Time.current
    game.should_not be_played
    game.should_not_receive :score_bets!
    game.save!
  end
  
  it "should not score the related bets until after the game was played" do
    game = Game.new(@valid_attributes)
    game.goals_a = 1
    game.goals_b = 2
    game.played_at.should > Time.current
    game.should_not be_played
    game.should_not_receive :score_bets!
    game.save!
  end
  
  describe ".score_bets!" do
    it "should call Bet#score! in each related bet" do
      game = games(:group_win)
      bets = game.bets.all
      bets.size.should == 2
      bet1 = bets.first
      bet2 = bets.last
      bet1.should_receive(:score!)
      bet2.should_receive(:score!)
      game.stub_chain(:bets, :all).and_return([bet1, bet2])
      game.score_bets!
    end
  end
  
  context "group games" do
    
    it "both teams should be from the same group" do
      game = Game.new(@valid_attributes.with(:team_b => teams(:arg)))
      game.team_a.group.should_not == game.team_b.group
      game.should_not be_valid
      game.errors.full_messages.should include("Times devem ser do mesmo grupo")
    end
    
  end
  
  context "finals games" do 
    
    it "teams can be from different groups" do
      game = Game.new(@valid_attributes.with(:stage => 'Semis', :team_b => teams(:arg)))
      game.team_a.group.should_not == game.team_b.group
      game.should be_valid
    end
    
    it "should not allow a tie between penaltys" do
      game = Game.new(
        :stage => 'Quartas',
        :played_at => 1.week.ago,
        :team_a => teams(:bra), 
        :team_b => teams(:por),
        :goals_a => 1,
        :goals_b => 1
      )
      game.should_not be_group_game
      game.penalty_goals_a = 4
      game.penalty_goals_b = 4
      game.should_not be_valid
      game.errors.full_messages.should include("Deve haver um vencedor na disputa de pênaltis")
    end
    
  end
  
  describe "figure_out_winner_and_loser" do
    before(:each) do
      @team_a = teams(:bra)
      @team_b = teams(:por)
      @game = Game.new(
        :played_at => 1.week.ago,
        :team_a => @team_a, 
        :team_b => @team_b
      )
    end
    context "group games" do
      before(:each) do
        @game.stage = 'Grupos'
      end
      it "should set A as the winner" do
        @game.goals_a = 2
        @game.goals_b = 1
        @game.save!
        @game.winner.should == @team_a
        @game.loser.should == @team_b
      end
      it "should set B as the winner" do
        @game.goals_a = 1
        @game.goals_b = 2
        @game.save!
        @game.winner.should == @team_b
        @game.loser.should == @team_a
      end
      it "should set a tie" do
        @game.goals_a = 1
        @game.goals_b = 1
        @game.save!
        @game.winner.should be_nil
        @game.loser.should be_nil
        @game.should be_tie
        @game.should_not be_penalty
      end
    end
    context "final games" do
      before(:each) do
        @game.stage = 'Oitavas'
      end
      it "should set A as the winner" do
        @game.goals_a = 2
        @game.goals_b = 1
        @game.save!
        @game.winner.should == @team_a
        @game.loser.should == @team_b
      end
      it "should set B as the winner" do
        @game.goals_a = 1
        @game.goals_b = 2
        @game.save!
        @game.winner.should == @team_b
        @game.loser.should == @team_a
      end
      it "should set A as the winner via penaltys" do
        @game.goals_a = 2
        @game.goals_b = 2
        @game.penalty_goals_a = 5
        @game.penalty_goals_b = 3
        @game.save!
        @game.should_not be_tie
        @game.should be_penalty
        @game.winner.should == @team_a
        @game.loser.should == @team_b
      end
      it "should set B as the winner via penaltys" do
        @game.goals_a = 2
        @game.goals_b = 2
        @game.penalty_goals_a = 3
        @game.penalty_goals_b = 5
        @game.save!
        @game.should_not be_tie
        @game.should be_penalty
        @game.winner.should == @team_b
        @game.loser.should == @team_a
      end
      it "should not set a tie" do
        @game.goals_a = 1
        @game.goals_b = 1
        @game.penalty_goals_a.should be_nil
        @game.penalty_goals_b.should be_nil
        @game.should_not be_valid
        @game.should_not be_tie
        @game.should be_penalty
      end
    end
  end
  
end

