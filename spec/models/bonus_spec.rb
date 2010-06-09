require 'spec_helper'

describe Bonus do
  before(:each) do
    @valid_attributes = {
      :question => "value for question",
      :answer => "value for answer",
      :points_awarded => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Bonus.create!(@valid_attributes)
  end
end
