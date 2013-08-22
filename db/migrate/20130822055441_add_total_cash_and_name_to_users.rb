class AddTotalCashAndNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_cash, :integer, :default => 0
    add_column :users, :name, :string
  end
end
