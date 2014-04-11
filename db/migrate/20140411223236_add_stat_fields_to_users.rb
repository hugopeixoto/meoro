class AddStatFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_spent, :decimal, default: 0.0
    add_column :users, :total_won, :decimal, default: 0.0
    add_column :users, :number_of_bets, :integer, default: 0
  end
end
