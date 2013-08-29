class AddWeekToGames < ActiveRecord::Migration
  def change
    add_column :games, :week, :integer unless Game.attr_accessible(:week)
  end
end
