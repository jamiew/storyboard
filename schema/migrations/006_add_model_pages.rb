class AddModelPages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
    end    
  end

  def self.down
    drop_table :pages
  end
end
