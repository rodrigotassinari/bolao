require 'spec_helper'

describe User do
  fixtures :users

  before(:each) do
    @valid_attributes = {
      :name => "Fulano de Tal",
      :email => "fulano@exemplo.com.br",
      :password => "123456",
      :password_confirmation => "123456"
    }
  end

  it "should create a new instance given valid attributes" do
    user = User.new(@valid_attributes)
    user.should be_valid
    user.save!
  end
  
  describe ".update_points_cache!" do
    fixtures :users, :bets
    it "should set the points_cache to the sum of user bets" do
      user = users(:user)
      user.points_cache.should == 0
      user.bets.should_not be_empty
      user.bets.map(&:points).reject { |i| i.nil? }.sort.should == [0, 4, 4, 5]
      user.update_points_cache!
      user.reload
      user.points_cache.should == 13
    end
  end
  
end

