class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :favorite_id
      t.string :spread
      t.string :home_team_id
      t.integer :home_score
      t.string :away_team_id
      t.integer :away_score
      t.datetime :start_date

      t.timestamps
    end
  end
end
