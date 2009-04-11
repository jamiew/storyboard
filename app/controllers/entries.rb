class Entries < Application
  provides :xml, :js, :yaml
  
  def index
    @entries = Entry.find(:all, :order => :updated_at)
    render @entries
  end
  
  def show
    @entry ||= Entry.find_by_identifier(params[:id])
    @entry ||= Entry.find(params[:id])
        
    # redirect url(:edit_entry, @entry) if @entry.pending?
    if @entry.nil?
      render :inline => "Could not find entry with identifier: #{params[:id]}"      
    elsif @entry.pending?
      render @entry, :action => :edit
    else
      render @entry
    end
  end
  
  def new
    only_provides :html
    @entry = Entry.new(params[:entry])
    puts "entry::new"
    render
  end
  
  def create
    @entry = Entry.new(params[:entry])
    if @entry.save
      redirect url(:entry, @entry)
    else
      render :action => :new
    end
  end
  
  def edit
    only_provides :html
    @entry = Entry.find(params[:id])
    if @entry.completed? # double sanity check; hmm
      render :inline => "This entry has already been created! Can't edit again."
    else
      render
    end
  end
  
  def update
    @entry = Entry.find(params[:id])
    puts "Entries::update"
    raise "No value specified!" unless params[:entry][:value]
    raise "Entry has already been updated!" if @entry.completed? 
    if @entry.update_attributes(params[:entry])
      @entry.completed!
      redirect url(:game, @entry.game)
    else
      raise BadRequest
    end
  rescue
    render :inline => "<h1>Holy snikeys!</h1> <p>ERROR: #{$!}<p>please email <em>support@</em> this domain name"
  end
  
  def destroy
    @entry = Entry.find(params[:id])
    if @entry.destroy
      redirect url(:entrys)
    else
      raise BadRequest
    end
  end
  
  
  def send_invite
    @entry ||= Entry.find_by_identifier(params[:id])
    @entry ||= Entry.find(params[:id])
    @entry.send_invite
    render :inline => "<h1>Invite sent</h1>"
  end
end