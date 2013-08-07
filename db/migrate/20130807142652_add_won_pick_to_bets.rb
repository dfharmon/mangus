class AddWonPickToBets < ActiveRecord::Migration
  def change
    add_column :bets, :won, :boolean
    add_column :bets, :pick_team_id, :integer
  end
end
