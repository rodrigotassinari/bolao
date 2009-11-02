require 'spec_helper'

describe Bet do
  fixtures :bets

  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :game_id => 1,
      :goals_a => 1,
      :goals_b => 1,
      :penalty => true,
      :penalty_goals_a => 4,
      :penalty_goals_b => 3
    }
  end

  it "should create a new instance given valid attributes" do
    bet = Bet.new(@valid_attributes)
    bet.should be_valid
    #Bet.create!(@valid_attributes)
  end

  # validando as fixtures, pois são bem complexas
  describe "fixtures" do
    Bet.all.each do |bet|
      it "should be valid: #{bet.user_id}" do
        bet.should be_valid
      end
    end
  end

  # Validações

end
