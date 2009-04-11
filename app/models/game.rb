class Game < ActiveRecord::Base
  has_many :sheets, :dependent => :destroy
  has_many :entries, :through => :sheets

  has_many :game_users, :dependent => :destroy
  has_many :users, :through => :game_users
  validates_associated :users, :on => :create
  
  validates_uniqueness_of :name, :on => :create, :message => " must be unique"
  validates_uniqueness_of :url, :on => :create, :message => " must be unique"
  validates_presence_of :turns, :on => :create, :message => " can't be blank"
  
  def destroy_sheets
    (self.sheets.to_a).each { |s| puts "Destroying #{s.inspect}"; s.destroy }
  end
  def destroy_users
    (self.users.to_a).each { |s| puts "Destoying user #{s.inspect}"; s.destroy }
  end
  
  def url=(newurl)
    puts self.url
    super
    puts self.url
    self.attributes['url'] = newurl.gsub(/[^a-z._0-9 -]/i, "").tr(".", "_").gsub(/(\s+)/, "_").dasherize.downcase
    puts self.url
  end
  
  
  
  def owner
    users[0] # owner is first user, FIXME!
  end
  alias :user :owner
  
  def completed_entries
    entries.select { |u| u.completed? }
  end
  
  def pending_entries
    entries.select { |u| not u.completed? }
  end
    
  def completed?
    pending_entries.length <= 0
  end
  alias :finished? :completed?
  
  def last_updated
    entries.last.updated_at
  end
  
  
  def remove_player
    # TODO
    # delete user from game
    # delete user's sheets?
  end
  alias :remove_user :remove_player

end