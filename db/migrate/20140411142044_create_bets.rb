class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :low
      t.integer :high
      t.integer :roll
      t.decimal :amount
      t.references :user, index: true

      t.timestamps
    end
  end
end
