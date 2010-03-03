class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :registerable, :authenticatable, :rememberable, :validatable, :http_authenticatable, :token_authenticatable, :lockable, :timeoutable, :activatable, :confirmable, :recoverable
  devise :facebook_connectable, :trackable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :name

  DEFAULT_PREFERENCES = {
    :receive_newsletter => true
  }

  serialize :preferences, Hash

  has_one :bet

  validates_presence_of :name
  
  validates_uniqueness_of :name

  attr_accessible :name

  # default attribute values
  def after_initialize
    if new_record?
      # set defaults only if the attribute is not set already
      self.preferences = DEFAULT_PREFERENCES if self.preferences.nil?
    end
  end

end

