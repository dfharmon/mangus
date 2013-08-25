class Standings < ActiveRecord::Base
  attr_accessible :user_id, :wins, :losses, :total_cash, :week

  belongs_to :user


end
