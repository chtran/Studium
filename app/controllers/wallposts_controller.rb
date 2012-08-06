class WallpostsController < ApplicationController

  def create_wallpost
    @post = Wallpost.create receiver_id: params[:receiver_id],sender_id: current_user.id,content: params[:content]

    publish_async('profile_'+params[:receiver_id], 'update_wallposts',{
      wallpost: render_to_string(@post)
    })

    render json: {
    }
  end
end
