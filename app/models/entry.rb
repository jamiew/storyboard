class Entry < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :user
  delegate :game, :to => :sheet
  # delegate_to :shipping_address, :first_name, :last_name, ..., 
  #              :prefix => 'shipping', :writer => true

  before_create :generate_identifier
  after_create :send_invite


  def generate_identifier
    hash = Digest::MD5.hexdigest("#{id}:#{sheet_id}:#{user_id}:#{created_at}")
    self.identifier = hash
  end    

  def send_invite
    puts "Entry::send_invite; entry id: #{self.id}, identifier: #{self.identifier}, to: #{user.email}"

    server = case ENV['MERB_ENV']
    when 'production'
      "http://dev.eyebeam.org:4001"
    else
      "http://localhost:4001"
    end
    
    what = case kind
    when 'image'
      "an image"
    when 'text'
      "a caption"
    end

    text = "
    
    someone wants you to add #{what} to the game '#{self.sheet.game.name}'
    
    #{server}/entries/#{self.identifier}
    
    peace out bitches,
    StoryBored.org
    "

    m = Merb::Mailer.new :to => user.email,
                         :from => 'Storyboard <nobody@jamiedubs.com>',
                         :subject => "[storyboard] yr turn in #{self.sheet.game.name}",
                         # :html => text,
                         :text => text
    m.deliver!
        
    # EntriesMailer.dispatch_and_deliver(:entry_invite, 
    #     :to => user.email,
    #     :from => 'jamie@tramchase.com',
    #     :subject => "[storyboard] it's yr turn!",
    #     # :html => text,
    #     :text => text)

  end
  
  def self.pending # uncompleted games
    self.find(:all, :conditions => ["identifier_expired_on IS NULL"])
  end
  def self.completed # finished games
    self.find(:all, :conditions => ["identifier_expired_on IS NOT NULL"])
  end
  
  
  def pending?
    return identifier_expired_on.nil?
  end
  alias :open? :pending?

  def completed?
    return !identifier_expired_on.nil?
  end
  alias :finished? :completed?
  
  
  def completed!
    # raise "already expired" unless self.identifier_expired_on.nil?
    self.identifier_expired_on = Time.now
    save(false)
    begin
      pass_it_on 
    rescue GameCompletedException
      puts "This game is finished!"
      self.game.complete!    
    rescue 
      puts "Error while passing it on! #{$!}"
    end
  end
  alias :expire! :completed!
  
   # send an invite to the next player
  def pass_it_on
    # should do sanity checking if a next one exists already, but oh well
    game = self.sheet.game # blah
    raise GameCompletedException if self.sheet.entries.length >= game.turns
    entry = Entry.new
    entry.sheet = self.sheet
    users = self.sheet.game.users
    puts users.inspect
    entry.user = users[users.index(self.user) + 1] || users.first # next user (or loop?)
    entry.kind = self.kind == 'image' ? 'text' : 'image'
    entry.save # will send the invite email
  end
  
    
end

# exception stubs
class GameCompletedException < Exception; end

