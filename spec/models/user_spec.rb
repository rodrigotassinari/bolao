require 'spec_helper'

describe User do
  fixtures :users

  before(:each) do
    @valid_attributes = {
      :login => 'ciclano',
      :email => 'ciclano@exemplo.com.br',
      :password => '123456',
      :password_confirmation => '123456'
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  # validando as fixtures, pois são bem complexas
  describe "fixtures" do
    User.all.each do |user|
      it "should be valid: #{user.name}" do
        user.should be_valid
      end
    end
  end

  # Opções

  it { should allow_mass_assignment_of(:login, :email, :name, :password, :password_confirmation) }

  # Validações

  it { should validate_presence_of(:email, :login, :preferences) }

  it { should validate_uniqueness_of(:email, :login) }

  # Defaults

  it "should initialize default values if new record" do
    u = User.new
    u.preferences.should == User::DEFAULT_PREFERENCES
  end
  it "should not initialize default values if not new record" do
    u = User.find_by_login('mestre_dos_magos')
    u.preferences.should_not == User::DEFAULT_PREFERENCES
  end

end
