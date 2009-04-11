class Games < Application
  provides :xml, :js, :yaml
  
  def index
    puts "session: #{session.inspect}"    
    @games = Game.find(:all, :include => :entries)
    render @games
  end
  
  def show
    puts "show: #{params[:id]}"
    @game = Game.find_by_url(params[:id])
    @game ||= Game.find_by_name(params[:id])
    @game ||= Game.find(params[:id]) # try again?
    raise "Could not find show for #{params[:id]}!" if @game.nil?
    render @game
  end
  
  def new
    only_provides :html
    @game = Game.new(params[:game])
    render
  end
  
  def create
    puts "Game::create"
    @game = Game.new(params[:game])
    @game.url.gsub!(/\s/, '-') # should do more too
    if @game.save
      params[:user].each do |key, value|
        next if key.nil? or value.nil? or value.empty? # skip empties        
        puts "#{key} => #{value}"
        user = User.find_or_initialize_by_email(value)
        user.save

        ## add user to the game
        @game.users << user
        puts @game.users.inspect
      end
      
      # used to be in after_create... hmm
      self.initialize_sheets

      puts "done, redirecting"
      redirect url(:game, :id => @game.url)
    else
      render :inline => '<div class="erorr">'+@game.errors.map { |k,v| "#{k} #{v}" }.join(', ')+"</div>"
      render :action => :new
    end
  end
  
  def initialize_sheets
    puts "initializing sheets..."
    @game ||= Game.find_by_name(params[:id])
    @game ||= Game.find(params[:id])
    puts "game = #{@game.inspect}"
    
    @game.destroy_sheets # clean up anything from before; FIXME maybe just in a ! method?
    puts "users? #{@game.users.length}"
        
    @game.users.each do |user|
      puts "Creating sheet for user: #{user.name}..."
      sheet = Sheet.new
      sheet.save rescue (raise "Could not create initialize sheet!")
      @game.sheets << sheet
      
      puts "Created sheet #{sheet.id}"
      
      ## redirect to the first entry for the sheet
      puts "user_id = #{user.id}, sheet_id = #{sheet.id}"
      entry = Entry.new(:user_id => user.id, :sheet_id => sheet.id)
      entry.save rescue (raise "Could not create an entry for said sheet!: #{$!} / #{entry.errors.inspect}")
      # sheet.entries << entry
    end
        
    render :inline => "Game initialized!"
  end
  
  def edit
    only_provides :html
    @game = Game.find(params[:id])
    render :action => :new
  end
  
  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      redirect url(:game, @game)
    else
      raise BadRequest
    end
  end
  
  def destroy
    @game = Game.find(params[:id])
    if @game.destroy
      redirect url(:games)
    else
      raise BadRequest
    end
  end
end
