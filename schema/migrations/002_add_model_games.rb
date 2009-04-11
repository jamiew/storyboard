class AddModelGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.column :name, :string 
      t.column :url, :string 
      t.column :owner_id, :integer 
      t.column :turns, :integer 
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end    
  end

  def self.down
    drop_table :games
  end
end
