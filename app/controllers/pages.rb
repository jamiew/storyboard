class Pages < Application
  provides :xml, :js, :yaml
  
  def show
    id = params[:page]
    puts "render = #{id}"
    # render :template => "pages/#{id}"
    # render :text => id
    render :template => "pages/#{id}"
  end  
  
end