require 'spec_helper'

describe Comment do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Comment.create!(@valid_attributes)
  end
end
