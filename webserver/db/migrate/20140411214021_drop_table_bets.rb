class DropTableBets < ActiveRecord::Migration
  def change
    drop_table :bets
  end
end
