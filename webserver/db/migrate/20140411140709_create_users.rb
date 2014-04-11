class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :hash
      t.decimal :balance
      t.string :name

      t.timestamps
    end
  end
end
