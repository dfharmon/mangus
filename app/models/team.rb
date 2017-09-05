class Team < ActiveRecord::Base
   attr_accessible :location, :mascot

  validates_uniqueness_of :location, { scope: :mascot }
end
