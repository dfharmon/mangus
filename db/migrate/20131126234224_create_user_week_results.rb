class CreateUserWeekResults < ActiveRecord::Migration
  def change
    create_table :user_week_results do |t|
      t.integer :user_id
      t.integer :week
      t.integer :result
      t.integer :win
      t.integer :loss
      t.timestamps
    end
  end
end
