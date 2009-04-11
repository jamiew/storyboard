class AddModelGameUsers < ActiveRecord::Migration
  def self.up
    create_table :game_users do |t|
      t.column :game_id, :integer
      t.column :user_id, :integer
    end    
  end

  def self.down
    drop_table :game_users
  end
end
