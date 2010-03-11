require 'spec_helper'

describe Game do
  fixtures :teams, :games
  
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
  
  context "group games" do
    
    it "both teams should be from the same group" do
      game = Game.new(@valid_attributes.with(:team_b => teams(:arg)))
      game.team_a.group.should_not == game.team_b.group
      game.should_not be_valid
      game.errors.full_messages.should include("Times devem ser do mesmo grupo")
    end
    
  end
  
  context "finals games" do 
    # TODO
  end
  
end

