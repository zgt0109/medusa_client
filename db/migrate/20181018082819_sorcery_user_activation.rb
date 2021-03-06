class SorceryUserActivation < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activation_state, :string, :default => nil
    add_column :users, :activation_token, :string, :default => nil
    add_column :users, :activation_state_expires_at, :datetime, :default => nil

    add_index :users, :activation_token
  end
end
