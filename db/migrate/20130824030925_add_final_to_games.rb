class AddFinalToGames < ActiveRecord::Migration
  def change
    add_column :games, :final, :boolean
  end
end
