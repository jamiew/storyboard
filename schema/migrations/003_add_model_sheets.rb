class AddModelSheets < ActiveRecord::Migration
  def self.up
    create_table :sheets do |t|
      t.column :game_id, :integer 
      t.column :user_id, :integer 
      t.column :created_at, :datetime 
      t.column :updated_at, :datetime 
    end    
  end

  def self.down
    drop_table :sheets
  end
end
