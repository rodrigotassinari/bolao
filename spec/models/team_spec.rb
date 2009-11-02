require 'spec_helper'

describe Team do
  fixtures :teams

  before(:each) do
    @valid_attributes = {
      :name => "Alemanha",
      :acronym => "GER",
      :group => "C"
    }
  end

  it "should create a new instance given valid attributes" do
    Team.create!(@valid_attributes)
  end

  # validando as fixtures, pois são bem complexas
  describe "fixtures" do
    Team.all.each do |team|
      it "should be valid: #{team.name}" do
        team.should be_valid
      end
    end
  end

  # Validações

  it { should validate_presence_of(:name, :acronym, :group) }

  it { should validate_uniqueness_of(:name, :acronym) }

end
