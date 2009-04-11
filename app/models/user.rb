class User < ActiveRecord::Base

  has_many :game_user
  has_many :games, :through => :game_user
  has_many :sheets
  has_many :entries
  
  
  def pending_entries
    self.entries.select { |e| e.identifier_expired_on.empty? }
  end
  
  def completed_entries
    self.entries.select { |e| not e.identifier_expired_on.empty? }
  end
  
  
  def username
    email.gsub(/\@.*/,'')
  end
  
  
  def to_s
    username
  end
  
end