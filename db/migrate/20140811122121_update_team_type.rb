class UpdateTeamType < ActiveRecord::Migration
  def up
    change_column :games, :home_team_id, :integer
    change_column :games, :away_team_id, :integer
  end

  def down
    change_column :games, :home_team_id, :string
    change_column :games, :away_team_id, :string
  end
end
