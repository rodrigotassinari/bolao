require 'spec_helper'

describe Game do
  fixtures :games
  
  before(:each) do
    @valid_attributes = {
      :stadium => "Engenhão",
      :city => "Rio de Janeiro",
      :played_on => Date.new(2010, 7, 10),
      :group_game => true,
      :team_a_id => 1,
      :team_b_id => 2,
      :goals_a => 1,
      :goals_b => 2,
      :penalty => false,
      :winner_id => 2,
      :loser_id => 1,
      :tie => false
    }
  end

  it "should create a new instance given valid attributes" do
    Game.create!(@valid_attributes)
  end

  # validando as fixtures, pois são bem complexas
  describe "fixtures" do
    Game.all.each do |game|
      it "should be valid: #{game.played_on}" do
        game.should be_valid
      end
    end
  end

  # Validações

  it { should validate_presence_of(:stadium, :city, :played_on, :team_a_id, :team_b_id) }

  it { should validate_inclusion_of(:group_game, :penalty, :tie, :in => [true, false]) }

  subject { Game.new(@valid_attributes.merge(:tie => false, :played_on => 2.days.ago.to_date)) }
  it {
    subject.should_not be_tie
    subject.should be_played
    should validate_presence_of(:winner_id, :loser_id)
  }

  subject { Game.new(@valid_attributes.merge(:penalty => true, :played_on => 2.days.ago.to_date)) }
  it {
    subject.should be_penalty
    subject.should be_played
    should validate_presence_of(:penalty_goals_a, :penalty_goals_b)
  }

  # Métodos

  describe ".played?" do
    before(:each) do
      @game = Game.new(@valid_attributes)
    end
    it "should return false if the game's date is after today" do
      @game.played_on = 2.days.from_now.to_date
      @game.should_not be_played
    end
    it "should return true if the game's date is today" do
      @game.played_on = Date.today
      @game.should be_played
    end
    it "should return true if the game's date before today" do
      @game.played_on = 2.days.ago.to_date
      @game.should be_played
    end
  end

end
