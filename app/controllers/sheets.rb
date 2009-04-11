class Sheets < Application
  provides :xml, :js, :yaml
  
  def index
    @sheets = Sheet.find(:all)
    render @sheets
  end
  
  def show
    @sheet = Sheet.find(params[:id])
    render @sheet
  end
  
  def new
    only_provides :html
    @sheet = Sheet.new(params[:sheet])
    render
  end
  
  def create
    @sheet = Sheet.new(params[:sheet])
    if @sheet.save
      redirect url(:sheet, @sheet)
    else
      render :action => :new
    end
  end
  
  def edit
    only_provides :html
    @sheet = Sheet.find(params[:id])
    render
  end
  
  def update
    @sheet = Sheet.find(params[:id])
    if @sheet.update_attributes(params[:sheet])
      redirect url(:sheet, @sheet)
    else
      raise BadRequest
    end
  end
  
  def destroy
    @sheet = Sheet.find(params[:id])
    if @sheet.destroy
      redirect url(:sheets)
    else
      raise BadRequest
    end
  end
end