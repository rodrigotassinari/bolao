class User < ActiveRecord::Base

  DEFAULT_PREFERENCES = {
    :receive_newsletter => true
  }

  serialize :preferences, Hash

  has_one :bet

  validates_presence_of :email, :login, :preferences

  validates_uniqueness_of :email, :login

  attr_accessible :login, :email, :name, :password, :password_confirmation

  # default attribute values
  def after_initialize
    if new_record?
      # set defaults only if the attribute is not set already
      self.preferences = DEFAULT_PREFERENCES if self.preferences.nil?
    end
  end

end
