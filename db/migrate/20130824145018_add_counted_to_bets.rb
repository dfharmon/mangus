class AddCountedToBets < ActiveRecord::Migration
  def change
    add_column :bets, :counted, :boolean, default: false
  end
end
