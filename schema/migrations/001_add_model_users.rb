class AddModelUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login, :string
      t.column :crypted_password, :string
      t.column :salt, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :remember_token, :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string
      t.column :activated_at, :datetime
      t.column :password_reset_code, :string
      t.column :identity_url, :string
      t.column :name, :string
      t.column :email, :string
      t.column :website, :string 
      t.column :location, :string 
      t.column :zip, :string 
      t.column :title, :string 
      t.column :company, :string
      t.column :about, :text
    end    
  end

  def self.down
    drop_table :users
  end
end
