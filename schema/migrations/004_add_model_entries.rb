class AddModelEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.column :sheet_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :kind, :string, :default => "image"
      t.column :value, :string
      t.column :identifier, :string 
      t.column :identifier_expired_on, :datetime      
    end    
  end

  def self.down
    drop_table :entries
  end
end
