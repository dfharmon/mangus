class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.integer :user_id
      t.integer :week
      t.integer :wins
      t.integer :losses
      t.integer :total_cash

      t.timestamps
    end
  end
end
