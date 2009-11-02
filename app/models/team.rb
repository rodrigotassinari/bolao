class Team < ActiveRecord::Base

  validates_presence_of :name, :acronym, :group

  validates_uniqueness_of :name, :acronym

end
