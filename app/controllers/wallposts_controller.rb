class WallpostsController < ApplicationController

  def create_wallpost
#    @wallpost = Wallpost.new(params[:wallpost])
    receiver_id = params[:receiver_id].to_i
    sender_id   = params[:sender_id].to_i
    content     = params[:content].to_s
    profile_id  = User.find(receiver_id).profile.id.to_s

    new_wallpost = {
      receiver_id: receiver_id.to_s,
      sender_id: sender_id.to_s,
      content: content.to_s,
      profile_id: profile_id.to_s
    }

    w = Wallpost.new(new_wallpost)
    w.save

    new_post = User.find(receiver_id).profile.wallposts.last
    sender   = User.find(sender_id)
    publish_async('profile_'+profile_id, 'update_wallposts',{
      sender_image: sender.profile.image,
      content: new_post.content,
      time: Date.today,
      sender_name: sender.name
    })
  end

  def show

  end


end
