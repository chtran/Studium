class WallpostsController < ApplicationController

  def create_wallpost
    if @post = Wallpost.create(receiver_id: params[:receiver_id],sender_id: current_user.id,content: params[:content])

      publish_async('profile_'+params[:receiver_id], 'update_wallposts',{
        wallpost: render_to_string(@post)
      })

      new_activity = current_user.subjects.generate("post_wall")
      new_activity.object = User.find(params[:receiver_id])
      new_activity.save!
    end

    render json: {
    }
  end
end
