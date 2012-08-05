class WallpostsController < ApplicationController

  def create
#    @wallpost = Wallpost.new(params[:wallpost])
    gon.params = params 
    
  end

end
