class ChangeHashToTokenInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :hash, :token
  end
end
