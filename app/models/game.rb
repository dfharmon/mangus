class Game < ActiveRecord::Base
   attr_accessible :favorite_id, :spread, :home_team_id, :away_team_id, :start_date
   attr_accessor :favorite_id, :spread, :home_team_id, :away_team_id, :start_date
end
