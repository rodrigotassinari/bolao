require 'spec_helper'

describe BonusBet do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :bonus_id => 1,
      :answer => "value for answer",
      :points => 1,
      :scored_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    #BonusBet.create!(@valid_attributes)
  end
end
